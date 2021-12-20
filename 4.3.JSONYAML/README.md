### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-03-yaml/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import time
import json
import yaml

servers = {"drive.google.com":"", "mail.google.com":"", "google.com":""}

while True:
    for srvname, srvaddr in servers.items():
        ip_addr=socket.gethostbyname(srvname);
        if(srvaddr==""):
            servers[srvname]=ip_addr
            print(f"{srvname} - {ip_addr}")
        else:
            if(srvaddr!=ip_addr):
                #print("[ERROR] {} IP missmatch: {} {}".format(srvname,srvaddr,ip_addr))
                servers[srvname] = ip_addr
    with open('services.json', 'w') as sj:
        sj.write(json.dumps(servers, indent=2))
    with open('services.yml', 'w') as sy:
        sy.write(yaml.dump(servers, indent=2, explicit_start=True, explicit_end=True))
    time.sleep(1)
```

### Вывод скрипта при запуске при тестировании:
```
/usr/bin/python3.8 /home/vitalykay/devops-netology/4.3.JSONYAML/2.py
drive.google.com - 64.233.163.194
mail.google.com - 173.194.220.18
google.com - 64.233.165.139
Traceback (most recent call last):
  File "/home/vitalykay/devops-netology/4.3.JSONYAML/2.py", line 24, in <module>
    time.sleep(1)
KeyboardInterrupt

Process finished with exit code 130 (interrupted by signal 2: SIGINT)
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{
  "drive.google.com": "64.233.163.194",
  "mail.google.com": "173.194.220.18",
  "google.com": "64.233.165.139"
}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
---
drive.google.com: 64.233.163.194
google.com: 64.233.165.139
mail.google.com: 173.194.220.18
...
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
#!/usr/bin/env python3
import json
import os
import sys
import yaml

data = dict()


def read_json(fd):
    global data
    try:
        data = json.load(fd)
    except json.JSONDecodeError as jexc:
        if jexc.pos == 0:
            print("File is not JSON!")
            return 2
        else:
            print("JSON error in position " + str(jexc.pos))
            return 1
    else:
        print("File is good JSON")
        return 0


def read_yaml(fd):
    global data
    try:
        data = yaml.safe_load(fd)
    except yaml.YAMLError as yexc:
        if hasattr(yexc, 'problem_mark'):
            mark = yexc.problem_mark
            print(f"YAML Error position: ({mark.line}:{mark.column})")
            return 1
        else:
            print("File is not YAML")
            return 2
    else:
        print("File is good YAML")
        return 0


if len(sys.argv) == 2:
    convfile = sys.argv[1]
    filename, file_extension = os.path.splitext(convfile)
    print(file_extension)
    if os.path.isfile(convfile) and (file_extension == ".json" or file_extension == ".yml"):
        with open(convfile, 'r') as cf:
            result = read_json(cf)
        # сделал по условию тк json - подмножество yaml
        if result == 2:
            with open(convfile, 'r') as cf:
                result1 = read_yaml(cf)

        if result == 0 or result1 == 0:
            with open(filename + ".json", 'w') as wjf:
                wjf.write(json.dumps(data))
            with open(filename + ".yml", 'w') as wyf:
                wyf.write(yaml.dump(data))
    else:
        print("File is not *.json or *.yml")
        exit(2)
else:
    print("Usage: script.py *.[jsom|yml]")
    exit(1)
```

### Пример работы скрипта:
Исходные файлы из задания 2
```
#запуск без аргументов
vitalykay@sams:~/devops-netology/4.3.JSONYAML$ ./3.py
Usage: script.py *.[jsom|yml]

#запуск с неправильным файлом
vitalykay@sams:~/devops-netology/4.3.JSONYAML$ ./3.py 2.py
.py
File is not *.json or *.yml

#запуск с правильным JSON
vitalykay@sams:~/devops-netology/4.3.JSONYAML$ ./3.py services.json
.json
File is good JSON
{'drive.google.com': '64.233.163.194', 'mail.google.com': '142.251.1.83', 'google.com': '64.233.165.139'}

#Запуск с правильным YAML
vitalykay@sams:~/devops-netology/4.3.JSONYAML$ ./3.py services.yml
.yml
File is not JSON!
File is good YAML
{'drive.google.com': '64.233.163.194', 'google.com': '64.233.165.139', 'mail.google.com': '142.251.1.83'}

#Запуск со сломаным JSON
vitalykay@sams:~/devops-netology/4.3.JSONYAML$ ./3.py services.json
.json
JSON error in position 39
{}

#Запуск со сломаным YAML
vitalykay@sams:~/devops-netology/4.3.JSONYAML$ ./3.py services.yml
.yml
File is not JSON!
YAML Error position: (3:0)

#Запуск с YAML в .json файле
vitalykay@sams:~/devops-netology/4.3.JSONYAML$ ./3.py services.json
.json
File is not JSON!
File is good YAML
{'drive.google.com': '64.233.163.194', 'google.com': '64.233.165.139', 'mail.google.com': '173.194.73.17'}

#Запуск с JSON в .yml файле
vitalykay@sams:~/devops-netology/4.3.JSONYAML$ ./3.py services.yml
.yml
File is good JSON
{'drive.google.com': '64.233.163.194', 'google.com': '64.233.165.139', 'mail.google.com': '173.194.73.17'}
```

