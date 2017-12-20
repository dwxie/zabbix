#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os,sys
import json
#from tib import funcs

#ret =  funcs.run_shell_command_2('''sudo ps -ef|grep -v grep |grep -E 'codispatcher|codproducer'|wc -l''')
#if ret[0] == "ok":
#    if int(ret[1]) < 1:
#        sys.exit()

t = os.popen("""ls -l  /opt/cod*er/etc/*.yaml |awk -F '/etc/' '{print $NF}'|awk -F '.yaml' '{print $1}'""").readlines()
t_2 = []
for i in t:
    t_2.append(i.strip('\n').split('   ')[0].strip())
data = []
for i in t_2:
    data+= [{'{#PROCESS}':i}]
print json.dumps({'data':data})
