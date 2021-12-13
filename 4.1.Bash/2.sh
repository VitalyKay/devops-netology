#!/usr/bin/env bash
#while ((1==1))
#do
#	curl https://localhost:4757
#	if (($? != 0))
#	then
#		date > curl.log
#	fi
#done

ip_array=(192.168.0.2 173.194.222.113 87.250.250.242)
port=80
for a in {1..5}
do
  for ip in ${ip_array[@]}
  do
    curl --silent --connect-timeout 1 $ip:$port >/dev/null
    res=$?
    if ((res==0))
    then
      echo $ip доступен >>log
    else
      echo $ip не доступен >>log
    fi
  done
done
