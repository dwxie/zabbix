#!/usr/bin/python
#This script is used to discovery mongo port  server

import subprocess
import json

args='''awk -F':' '{print $1":"$2}' /etc/zabbix/scripts/mongodb_servers.txt'''
t=subprocess.Popen(args,shell=True,stdout=subprocess.PIPE).communicate()[0]
mongodbs=[]
 
for mongo in t.split('\n'):
    if len(mongo) != 0:
       mongodbs.append({'{#MONGO_HOST}':mongo})
print json.dumps({'data':mongodbs},indent=4,separators=(',',':'))
