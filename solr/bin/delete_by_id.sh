#!/bin/bash
#
# delete_by_id.sh [file]


file=$1
if [ -f "$file" ]
then
    while read id
    do
        url="http://localhost:8080/solr/all/update?stream.body=<delete><id>${id}</id></delete>"
        /usr/bin/wget -O /dev/null "$url"
    done < "$file"
else
    echo -e "File not found: ${file}"
fi