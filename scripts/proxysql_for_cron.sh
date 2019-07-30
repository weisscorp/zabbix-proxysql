#!/bin/bash
if [[ $1 == 'discovery' ]]; then
        comma=""
        printf '%s' '{"data":['
        while read line; do
                hostid=$(echo $line | awk  '{print $1}')
                hostname=$(echo $line | awk  '{print $2}')
                port=$(echo $line | awk  '{print $3}')
                printf '%s' "$comma{\"{#HOSTGROUP_ID}\": $hostid, \"{#SERVERNAME}\": \"$hostname\", \"{#SERVERPORT}\": $port}"
                comma=","
        done < /tmp/proxysql.tmp
        printf '%s' ']}'
elif [[ $1 == 'get' ]]; then
        comma=""
        while read line; do
                hostid=$(echo $line | awk  '{print $1}')
                hostname=$(echo $line | awk  '{print $2}')
                port=$(echo $line | awk  '{print $3}')
                if [ $2 == $hostid ] && [ $3 == $hostname ] && [ $4 == $port ]; then
                        status=$(echo $line | awk  '{print $4}')
                        weight=$(echo $line | awk  '{print $5}')
                        printf '%s' "$comma{\"status\":\"$status\","
                        printf '%s' "$comma\"weight\": $weight}"
                fi
        done < /tmp/proxysql.tmp
fi
