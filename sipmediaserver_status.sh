#!/bin/sh
port=`cat /opt/sipserver/sipserver.json|jq '.http.ipv4.port'`
ip=`cat /opt/sipserver/sipserver.json|jq '.http.ipv4.addr'|sed -r 's/.*"(.+)".*/\1/'`
status=`curl  -s http://$ip:$port/sipserver/stat |jq '.mediasrv'|grep 'online'|awk -F ':' '{print $2}'`
echo $status
