#Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

1. 
| Переменная | Значение| Обоснование                                                                           |
| ------- | ------ |---------------------------------------------------------------------------------------|
| c | a+b | переменной с присваивается строка 'a+b'                                               |
| d | 1+2 | в переменную d записывается строка с подстановкой значений строковых переменных a и b |
| e | 3 | в двойных скобках производятся арифметические вычисления                              |

2. Исправленный скрипт первой части (забыли скобку в условии while  и >> надо заменить на > для перезаписи файла)
```
while ((1==1))
do
    curl https://localhost:4757
    if (($? != 0))
    then
        date > curl.log
    fi
done
```

```commandline
ip_array=(192.168.0.2 173.194.222.113 87.250.250.242)
port=80
for a in {1..5}
do
  for ip in ${ip_array[@]}
  do
    curl --silent --connect-timeout 1 $ip:$port >/dev/null
    if (($?==0))
    then
      echo $ip доступен >>log
    else
      echo $ip не доступен >>log
    fi
  done
done
```
3. 
```commandline
#!/usr/bin/env bash
ip_array=(192.168.0.40 173.194.222.113 87.250.250.242)
port=80

while true
do
  for ip in ${ip_array[@]}
  do
    curl --silent --connect-timeout 1 $ip:$port >/dev/null
    if (($?!=0))
    then
      echo $ip >error
      exit
    fi
  done
done
```
4. Файл commit-msg
```commandline
#!/usr/bin/env bash

commit_message=$(head -n1 $1)

comreg=$(echo $commit_message | grep -E "^\[[0-9][0-9]-[a-z]+-[0-9][0-9]-[a-z]+\]\s.+$")

if [[ ${#commit_message} -gt 30 && -n $comreg ]]
then
  echo Сообщение коммита должно быть не более 30 символов и соответствовать шаблону "[NN-block-MM-topic] коментарий"
  echo NN-номер блока, MM-номер темы
  exit 1
else
  echo Все ок
  exit 0
fi
```