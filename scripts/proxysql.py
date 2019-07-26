#!/usr/bin/env python3
# -*- coding: utf-8

import sys
import json
import mysql.connector

proxysql_host     = "127.0.0.1"
proxysql_port     = 6032
proxysql_user     = "admin"
proxysql_password = "admin"

connection = mysql.connector.connect(host=proxysql_host, port=proxysql_port, user=proxysql_user, passwd=proxysql_password, db="main")
cursor = connection.cursor()

if sys.argv[1] == 'discovery':
    cursor.execute("""SELECT `hostgroup_id`, `hostname`, `port`, `status`, `weight` 
            FROM `runtime_mysql_servers`;""")
    result = cursor.fetchall()
    discovery = {"data":[]}
    for server in result:
        discovery["data"].append({"{#HOSTGROUP_ID}":int(server[0]), "{#SERVERNAME}":server[1], "{#SERVERPORT}":int(server[2])})
    print(json.dumps(discovery, indent=2, sort_keys=True))
    sys.exit(0)
elif sys.argv[1] == 'get':
    sql = "SELECT status, weight FROM runtime_mysql_servers WHERE hostgroup_id = \'"+ sys.argv[2] +"\' AND hostname = \'"+ sys.argv[3] +"\' AND port = \'"+ sys.argv[4] +"\';"
    cursor.execute(sql)
    result = cursor.fetchall()
    for server in result:
        print({"status": server[0], "weight": int(server[1])})
    sys.exit(0)
