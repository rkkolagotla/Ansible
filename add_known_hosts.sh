#!/bin/bash
#Script Written by Rajesh Moturi(rx393v)

invpath="/home/ansible/inventory"
DIR="$invpath/host_vars"
known_hosts="/home/ansible/.ssh/known_hosts"

ID=$(id | awk -F "(" '{print $2}' | awk -F ")" '{print $1}')

if [ $ID != ansible ];then
echo -e "\nThis script needs to run as ansible..Exiting.." && exit
fi

for i in $(ls $DIR/*)
do
add_host=""
remote_host=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $i 2>/dev/null)
if [ -n "$remote_host" ];then
echo -e "\n$remote_host : Checking if host key already exists in $known_hosts\n"
grep $remote_host $known_hosts || add_host=$remote_host
if [ -n "$add_host" ];then
echo -e "$add_host : Adding Host Key to ${known_hosts}\n"
ssh-keyscan -H $add_host &>> $known_hosts
fi
fi
done
