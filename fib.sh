#!/bin/bash

fibonacci(){
a = 0
b = 1
c = 0
if[[$1>=1]];then
echo "0"
fi

if[[$1>=2]];then
echo "1"
fi
if[[$1>2]];then
for((i=0;i<$1;i++))do
c=((a+b))
a=b
b=c
echo $c
done
}

fibonacci 3
