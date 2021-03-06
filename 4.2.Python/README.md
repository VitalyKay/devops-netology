### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ                                             |
| ------------- |---------------------------------------------------|
| Какое значение будет присвоено переменной `c`?  | ошибка при попытке сложить строковый и целый типы |
| Как получить для переменной `c` значение 12?  | c = str(a) + b                                    |
| Как получить для переменной `c` значение 3?  | c = a + int(b)                                    |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

repopath = "~/testrepo"

bash_command = [f"cd {repopath}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = os.path.expanduser(repopath) + "/" + result.replace('\tизменено:   ', '').strip()
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
/usr/bin/python3.8 /home/vitalykay/devops-netology/4.2.Python/2.py
/home/vitalykay/testrepo/1.py
/home/vitalykay/testrepo/2.py
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

if (len(sys.argv) ==2):
    repopath = sys.argv[1]
else:
    print("Usage: script.py repository_path")
    exit(1)

if (not os.path.exists(repopath+"/.git")):
    print("Path is not a repository")
    exit(2)

bash_command = [f"cd {repopath}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = os.path.expanduser(repopath) + "/" + result.replace('\tизменено:   ', '').strip()
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
vitalykay@sams:~/devops-netology/4.2.Python$ ./3.py
Usage: script.py repository_path
vitalykay@sams:~/devops-netology/4.2.Python$ ./3.py /home/vitalykay
Path is not a repository
vitalykay@sams:~/devops-netology/4.2.Python$ ./3.py ~/testrepo
/home/vitalykay/testrepo/1.py
/home/vitalykay/testrepo/2.py

```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket

servers = {"drive.google.com":"", "mail.google.com":"", "google.com":""}

while True:
    for srvname, srvaddr in servers.items():
        ip_addr=socket.gethostbyname(srvname);
        if(srvaddr==""):
            servers[srvname]=ip_addr
            print(f"{srvname} - {ip_addr}")
        else:
            if(srvaddr!=ip_addr):
                print("[ERROR] {} IP missmatch: {} {}".format(srvname,srvaddr,ip_addr))
                servers[srvname] = ip_addr

```

### Вывод скрипта при запуске при тестировании:
```
/usr/bin/python3.8 /home/vitalykay/devops-netology/4.2.Python/4.py
drive.google.com - 64.233.163.194
mail.google.com - 74.125.131.83
google.com - 74.125.205.139
[ERROR] google.com IP missmatch: 74.125.205.139 74.125.205.100
[ERROR] drive.google.com IP missmatch: 64.233.163.194 173.194.220.194
[ERROR] mail.google.com IP missmatch: 74.125.131.83 173.194.73.17
[ERROR] mail.google.com IP missmatch: 173.194.73.17 173.194.73.18
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
#!/usr/bin/env python3
from github import Github
import os

token = "ghp_AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
remoterepo = "VitalyKay/testrepo"
branchname = "newconf"

body = "New Configuration"

local_repo = "~/testrepo"
minusb = " -b"

g = Github(token)

bash_command = [f"cd {local_repo}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        bash_command = f"cd {local_repo} && git branch"
        result_os = os.popen(bash_command).read()
        for ex_br in result_os.split('\n'):
            if ex_br.find("newconf") != -1:
                minusb = ""
        bash_command = f"cd {local_repo} && git checkout{minusb} {branchname} && git commit -am 'New Config#50' && " \
                       f"git push -u origin {branchname}"
        if os.system(bash_command) != 0:
            print("Push error")
            break
        repo = g.get_repo(remoterepo)
        pr = repo.create_pull(title="New Config", body=body, head=branchname, base="main")
        print(pr.title+" "+str(pr.number))
        break
```

### Вывод скрипта при запуске при тестировании:
```
/usr/bin/python3.8 /home/vitalykay/devops-netology/4.2.Python/5.py
M	1.py
Ваша ветка обновлена в соответствии с «origin/newconf».
[newconf 5409893] New Config#50
 1 file changed, 1 insertion(+)
Переключено на ветку «newconf»
remote: 
remote: Create a pull request for 'newconf' on GitHub by visiting:        
remote:      https://github.com/VitalyKay/testrepo/pull/new/newconf        
remote: 
To github.com:VitalyKay/testrepo.git
 * [new branch]      newconf -> newconf
Ветка «newconf» отслеживает внешнюю ветку «newconf» из «origin».
New Config 3

Process finished with exit code 0

```