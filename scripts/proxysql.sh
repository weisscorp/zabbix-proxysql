#!/bin/bash
mysql -u admin -padmin -h 127.0.0.1 -P6032 -h 0  -e "SELECT hostgroup_id, hostname, port, status, weight FROM runtime_mysql_servers" > /tmp/proxysql.tmp 2>/dev/null
sed -e '1d' -i /tmp/proxysql.tmp
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
