#!/bin/bash
mysql --local-path=admin -h 127.0.0.1 -P6032 -h 0  -e "SELECT hostgroup_id, hostname, port, status, weight FROM runtime_mysql_servers" > /tmp/proxysql.tmp 2>/dev/null
sed -e '1d' -i /tmp/proxysql.tmp