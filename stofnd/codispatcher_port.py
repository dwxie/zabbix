#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os,sys
import json
#from tib import funcs

#ret =  funcs.run_shell_command_2('''sudo ps -ef|grep -v grep |grep -E 'codispatcher|codproducer'|wc -l''')
#if ret[0] == "ok":
#    if int(ret[1]) < 1:
#        sys.exit()

t = os.popen("""grep 'statusPort:'   /opt/codispatcher/etc/*.codispatcher.yaml | awk -F ':' '{print $3}'""").readlines()
t_2 = []
for i in t:
    t_2.append(i.strip('\n').split('   ')[0].strip())
data = []
for i in t_2:
    data+= [{'{#WEB_PORT}':i}]
print json.dumps({'data':data})
