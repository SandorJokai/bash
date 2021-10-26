#!/bin/bash

countdown=20
curl='curl -k https://192.168.1.20/index.html'
count=1
second='nd'
third='rd'
others='th'

while [ $count -le 5 ]
do
  echo
  for i in $(seq $countdown -1 1)
  do
    echo "$i seconds has left to launching the next curl"
    sleep 1
  done
  $curl >/dev/null 2>&1
  count=$(( count + 1 ))
  if [ $count == 2 ];then
    echo;echo "$count$second run starts"
  elif [ $count == 3 ];then
    echo;echo "$count$third run starts"
  elif [[ $count == 4 || $count == 5 ]];then
    echo;echo "$count$others run starts"
  fi
done
echo
