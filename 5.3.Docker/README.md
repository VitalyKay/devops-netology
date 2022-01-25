# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

https://hub.docker.com/r/vitalykay/nginx

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;

Виртуальная или физическая машина - позводит выделить необходимое количество ресурсов.

- Nodejs веб-приложение;

Docker контейнер - позволит включить все зависимости и при необходимости масштабирования запускать дополнительные контейнеры.

- Мобильное приложение c версиями для Android и iOS;

Виртуальные машины - тк данные ОС используют разные ядра.

- Шина данных на базе Apache Kafka;

Docker контейнеры - поскольку это распределенная система.

- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;

Docker контейнеры - каждую ноду можно реализовать контейнером и поднять кластер через Docker Compose, что позволяет описать такую инфраструктуру как код.

- Мониторинг-стек на базе Prometheus и Grafana;

Docker контейнеры - по сути это web приложения и есть даже готовые образы, которые можно развернуть через Docker Compose.

- MongoDB, как основное хранилище данных для java-приложения;

Docker контейнер - есть официальный образ, хранилище можно подключить через volume.

- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

Docker контейнер - есть официальные образы, можно быстро развернуть и быть не привязанным к конкретному серверу.

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

```commandline
vagrant@server1:~$ docker run --name centos01 -v ~/data:/data -t -d centos bash
a22630f313a9485a43a7b1826d64a43d80569c7f0c412f89709a4c698ef6fa4b
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED          STATUS          PORTS     NAMES
a22630f313a9   centos    "bash"    13 seconds ago   Up 12 seconds             centos01
vagrant@server1:~$ docker run --name debian01 -v ~/data:/data -t -d debian bash
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
0e29546d541c: Pull complete 
Digest: sha256:2906804d2a64e8a13a434a1a127fe3f6a28bf7cf3696be4223b06276f32f1f2d
Status: Downloaded newer image for debian:latest
1ddf80ec68a26111d86c9799ae2565c4aede6395321d114072984bd034e1d59f
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS         PORTS     NAMES
1ddf80ec68a2   debian    "bash"    6 seconds ago   Up 4 seconds             debian01
a22630f313a9   centos    "bash"    2 minutes ago   Up 2 minutes             centos01
vagrant@server1:~$ docker exec -it centos01 bash
[root@a22630f313a9 /]# echo Hello from CentOS >/data/file_from_centos
[root@a22630f313a9 /]# cat /data/file_from_centos
Hello from CentOS
[root@a22630f313a9 /]# exit
exit
vagrant@server1:~$ echo Hello from Host>data/file_from_host
vagrant@server1:~$ cat data/file_from_host
Hello from Host
vagrant@server1:~$ ls data
file_from_centos  file_from_host
vagrant@server1:~$ docker exec -it debian01 bash
root@1ddf80ec68a2:/# ls /data
file_from_centos  file_from_host
root@1ddf80ec68a2:/# cat /data/file_from_centos
Hello from CentOS
root@1ddf80ec68a2:/# cat /data/file_from_host  
Hello from Host
root@1ddf80ec68a2:/# exit
exit

```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

https://hub.docker.com/r/vitalykay/ansible

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---