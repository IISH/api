#!/bin/bash

restart=/usr/local/api/restart.txt
if [ -f $restart ] ; then
    service tomcat6 stop
    pause 3
    service tomcat6 start
    rm $restart
    exit 0
fi

q="http://localhost:8080/solr/all/select/?q=iisg_identifier%3A0"
O=/tmp/tomcat.status.txt
wget -T 3 -t 3 -O $O $q
rc=$?
if [[ $rc != 0 ]] ; then
	echo "$(date) not the right response.">>/tmp/tomcat.status.log
	service tomcat6 stop
	sleep 5
	killall java
	sleep 5
	service tomcat6 start
	sleep 15
	wget -T 3 -t 3 -O $O $q
        rc=$?
        if [[ $rc != 0 ]] ; then
		echo "$(date) Stop tomcat.">>/tmp/tomcat.status.log
		service tomcat6 stop
	fi
fi
