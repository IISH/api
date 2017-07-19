#!/bin/bash
#
# delete_by_id.sh [file]


HOST="http://localhost:8080/solr/all"


file=$1
if [ -f "$file" ]
then
    while read id
    do
        url="${HOST}/update?stream.body=<delete><id>${id}</id></delete>"
        /usr/bin/wget -O /dev/null "$url"
    done < "$file"
    wget "${HOST}/update?commit=true"
else
    echo -e "File not found: ${file}"
fi