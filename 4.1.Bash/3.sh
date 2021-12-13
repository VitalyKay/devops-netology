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