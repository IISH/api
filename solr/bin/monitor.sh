#!/bin/bash
#
# monitor.sh [status file]
#
# Purpose: place a status file in the root of the web application if all is well.
# If not: replace the file and try to restart the applications.


if (( $(pgrep -c "monitor.sh") == 1 )) ; then
    echo "Self"
else
    echo "Already running"
    exit 1
fi


f=$1
if [ -z "$f" ] ; then
    echo "Warning. No file parameter found. Usage: ./monitor.sh /path/to/root/of/the/webapplication/status.txt"
    exit 1
fi

body=/tmp/body.txt
content=/tmp/content.txt
headers=/tmp/headers.txt
s=/opt/status.txt
q="http://127.0.0.1:8080/solr/all/select?q=*:*"

rm -f $f # This will remove the status.txt file
rm -f $content $headers

wget -S -T 5 -t 3 -O $content $q 2>$headers
rc=$?
if [[ $rc == 0 ]] ; then

    # The response time from Solr was ok.
    # Now check the CPU usage. It should not be higher than the CPU count.
    cpu_count=$(grep -c ^processor /proc/cpuinfo)
    benchmark="${cpu_count}.10"
    cpu_load=`cat /proc/loadavg | awk '{print $1}'`
    response=`echo | awk -v T=$benchmark -v L=$cpu_load 'BEGIN{if ( L > T){ print "1"} else {print "0"} }'`
    if [[ $response == 0 ]] ; then
        echo "$(date)">$f
        exit 0
    else
        rc=1
        sleep 30 # status.txt is removed, so we wait a little until the proxy no longer sends traffic.
    fi
fi

    echo "$(date): Invalid response ${rc}" >> $s

    # Headers
    if [ ! -f $headers ]
    then
        echo "There is no headers file." > $headers
    fi

    # Content
    if [ ! -f $content ]
    then
        echo "There is no content file." > $content
    fi

    echo "Headers:" > $body
    cat $headers >> $body
    echo "" >> $body

    echo "Content:" >> $body
    cat $content >> $body
    echo "" >> $body

    echo "Top:" >> $body
    top -b -n 1 >> $body
    echo "" >> $body

    echo "Restart event history:" >> $body
    cat $s >> $body

    service tomcat7 stop
    sleep 7
    killall java
    sleep 7
    service tomcat7 start
    sleep 30

    subject="${HOSTNAME} - Automatic restart by ${0}"
    /usr/bin/sendmail --body "$body" --from "search@${HOSTNAME}" --to "$MAIL_TO" --subject "$subject" --mail_relay "$MAIL_HOST"

    exit 1
