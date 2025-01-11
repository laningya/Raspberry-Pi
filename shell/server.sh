#!/usr/bin/bash

scriptPath=$(dirname "${BASH_SOURCE[0]}")
filePath="$scriptPath/myserver.json"

nums=`jq -r ".ServerInfo | length" $filePath`
for ((i=0; i<nums; i++)); do
    tag=`jq -r ".ServerInfo[$i].tag" $filePath`
    echo "`expr $i + 1`.$tag"
done

echo -n "请输入机器编号："
read num

num=`expr $num - 1`
IP=`jq -r ".ServerInfo[$num].IP" $filePath`
Port=`jq -r ".ServerInfo[$num].Port" $filePath`
User=`jq -r ".ServerInfo[$num].User" $filePath`

ssh  $User@$IP -p$Port