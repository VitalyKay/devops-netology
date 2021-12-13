#!/usr/bin/env bash

commit_message=$(head -n1 $1)

comreg=$(echo $commit_message | grep -E "^\[[0-9][0-9]-[a-z]+-[0-9][0-9]-[a-z]+\]\s.+$")

if [[ ${#commit_message} -gt 30 && -n $comreg ]]
then
  echo Сообщение коммита должно быть не более 30 символов и соответствовать шаблону "[код-задания] коментарий"
  exit 1
else
  echo Все ок
  exit 0
fi