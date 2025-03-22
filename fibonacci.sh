#!/bin/bash

fibonacci(){
a=0
b=1
c=0
if [[ $1 -ge 1 ]];then
 echo "0"
fi

if [[ $1 -ge 2 ]];then
 echo "1"
fi

if [[ $1 -gt 2 ]];then
 for((i=0;i<$1 - 1;i++))do
  c=$((a + b))
  a=$b
  b=$c
  echo $c
  cd /home
  mkdir -p resultado
  cd resultado
  echo $c >> resultado.txt

 done
fi
}

fibonacci $1
