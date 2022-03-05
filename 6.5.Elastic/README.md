# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
```dockerfile
FROM centos:7

EXPOSE 9200
EXPOSE 9300

ENV ES_PATH_CONF=/etc/elasticsearch
ENV ES_HOME=/usr/share/elasticsearch

COPY elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000

RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
RUN yum install -y java-1.8.0-openjdk.x86_64 && \
    yum install -y --enablerepo=elasticsearch elasticsearch && \
    yum clean all

RUN chmod 777 $ES_PATH_CONF

RUN rm -f $ES_PATH_CONF/elasticsearch.keystore

COPY elasticsearch.yml $ES_PATH_CONF/elasticsearch.yml

WORKDIR $ES_HOME/bin

ENV PATH=$PATH:$ES_HOME/bin

USER elasticsearch

CMD [ "./elasticsearch" ]
```
- ссылку на образ в репозитории dockerhub

[https://hub.docker.com/repository/docker/vitalykay/es_test](https://hub.docker.com/repository/docker/vitalykay/es_test)

- ответ `elasticsearch` на запрос пути `/` в json виде

```commandline
root@vagrant:~/elastic# curl -X GET http://127.0.0.1:9200/
{
  "name" : "netology_test",
  "cluster_name" : "es_cluster",
  "cluster_uuid" : "jbmLS6gfQCODBW7ZOD83Gg",
  "version" : {
    "number" : "8.0.1",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "801d9ccc7c2ee0f2cb121bbe22ab5af77a902372",
    "build_date" : "2022-02-24T13:55:40.601285296Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```commandline
root@vagrant:~/elastic# curl -XPUT "http://127.0.0.1:9200/ind-3/" -H 'Content-Type: application/json' -d'
{
  "settings":{
    "number_of_shards": 4,
    "number_of_replicas": 2
  }
}'
```

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
```commandline
root@vagrant:~/elastic# curl -X GET "http://127.0.0.1:9200/_cat/indices/?v=true"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 mcF42TU5RPOLHFxW7L_T2g   1   0          0            0       225b           225b
yellow open   ind-3 pWLJZP53QDuKqxDxoQOC_Q   4   2          0            0       900b           900b
yellow open   ind-2 JiEEm3kRScO4BMiqw28-BA   2   1          0            0       450b           450b
```

Получите состояние кластера `elasticsearch`, используя API.

```commandline
root@vagrant:~/elastic# curl -X GET "http://127.0.0.1:9200/_cluster/state/nodes/_all" | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   273  100   273    0     0  17062      0 --:--:-- --:--:-- --:--:-- 21000
{
  "cluster_name": "es_cluster",
  "cluster_uuid": "jbmLS6gfQCODBW7ZOD83Gg",
  "nodes": {
    "QTFoXsqySEePemhoiV0U_A": {
      "name": "netology_test",
      "ephemeral_id": "QyzkkYnARoOzpcQ0BKjySA",
      "transport_address": "172.17.0.2:9300",
      "attributes": {
        "xpack.installed": "true"
      },
      "roles": [
        "data",
        "master"
      ]
    }
  }
}
```

**Для вывода состояния всех метрик _all - слишком много инфы, привел только для узлов**

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Часть индексов и кластер находятся в состоянии yellow, потому что часть шард в индексах имеют состояние UNASSIGNED, так как количество реплик больше нод в ржиме data. 

Удалите все индексы.
```commandline
root@vagrant:~/elastic# curl -X DELETE "http://127.0.0.1:9200/ind-1/"
{"acknowledged":true}
root@vagrant:~/elastic# curl -X DELETE "http://127.0.0.1:9200/ind-2/"
{"acknowledged":true}
root@vagrant:~/elastic# curl -X DELETE "http://127.0.0.1:9200/ind-3/"
{"acknowledged":true}
```
По умолчанию не поддерживает * или _all. Но можно сконфигурировать параметр action.destructive_requires_name. 

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.
```commandline
root@vagrant:~/elastic# curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/usr/share/elasticsearch/snapshots"
  }
}'
{
  "acknowledged" : true
}
```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```commandline
root@vagrant:~/elastic# curl -XPUT "http://127.0.0.1:9200/test/" -H 'Content-Type: application/json' -d'
{
  "settings":{
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}

root@vagrant:~/elastic# curl -X GET "http://127.0.0.1:9200/_cat/indices/?v=true"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  9qDzrR2ZTAmRO28xBsceBQ   1   0          0            0       225b           225b
```

curl -X PUT "http://127.0.0.1:9200/_snapshot/netology_backup/testbackup?pretty"

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

```commandline
root@vagrant:~/elastic# curl -X PUT "http://127.0.0.1:9200/_snapshot/netology_backup/testbackup?pretty"
{
  "accepted" : true
}
```

**Приведите в ответе** список файлов в директории со `snapshot`ами.

```commandline
[root@ef25e87c7a8a bin]# cd /usr/share/elasticsearch/snapshots/
[root@ef25e87c7a8a snapshots]# ll
total 36
-rw-r--r-- 1 elasticsearch elasticsearch   843 Mar  5 07:55 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Mar  5 07:55 index.latest
drwxr-xr-x 4 elasticsearch elasticsearch  4096 Mar  5 07:55 indices
-rw-r--r-- 1 elasticsearch elasticsearch 17464 Mar  5 07:55 meta-DkuJtd9vTxevZgalDVYBIg.dat
-rw-r--r-- 1 elasticsearch elasticsearch   355 Mar  5 07:55 snap-DkuJtd9vTxevZgalDVYBIg.dat
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```commandline
root@vagrant:~/elastic# curl -X DELETE "http://127.0.0.1:9200/test/"
{"acknowledged":true}

root@vagrant:~/elastic# curl -XPUT "http://127.0.0.1:9200/test-2/" -H 'Content-Type: application/json' -d'
{
  "settings":{
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test-2"}

root@vagrant:~/elastic# curl -X GET "http://127.0.0.1:9200/_cat/indices/?v=true"
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 zJQCg-_PTCOXrvfRkiQ02Q   1   0          0            0       225b           225b
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

```commandline
root@vagrant:~/elastic# curl -X POST "http://127.0.0.1:9200/_snapshot/netology_backup/testbackup/_restore?pretty" -H 'Content-Type: application/json' -d'
{
  "indices": "test"
}'
{
  "accepted" : true
}

root@vagrant:~/elastic# curl -X GET "http://127.0.0.1:9200/_cat/indices/?v=true"
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 zJQCg-_PTCOXrvfRkiQ02Q   1   0          0            0       225b           225b
green  open   test   oNd2VztzQQmch4pmZLDH5Q   1   0          0            0       225b           225b
```

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---