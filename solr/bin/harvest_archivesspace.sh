#!/bin/bash

SQL='select id, repo_id  from resource;'
HOST='n-195-169-89-74.diginfra.net'
PASSWORD='13ace1fa-fb83-11ec-b00e-17642db5fe2a'
ID_FILE='/tmp/id.txt'
DOMEIN='https://as-oai.collections.iisg.org'

/usr/bin/mysql -h "$HOST" -u archivesspace -p"$PASSWORD" -BN -e "$SQL" archivesspace > "$ID_FILE"

for metadata_prefix in oai_ead oai_marc
do
  [ -d "$metadata_prefix" ] && rm "${metadata_prefix}/"*
  while read -r resource_id repo_id
  do
    # oai:archivesspace//repositories/2/resources/1
    identifier="oai:archivesspace//repositories/${repo_id}/resources/${resource_id}"
    url="${DOMEIN}?verb=GetRecord&identifier=${identifier}&metadataPrefix=${metadata_prefix}"
    f="${metadata_prefix}/${repo_id}_${resource_id}.xml"
    CMD="curl -X GET -o '${file}' -k '$url'"
    echo "$CMD" && eval "$CMD"
    (grep -q "idDoesNotExist" "$f" && echo "BAD ${f} - idDoesNotExist ${identifier} in ${f}" && rm "$f") || echo "OK ${f}"
  done < "$ID_FILE"
done


java -jar org.socialhistory.solr.importer.BatchImport /home/lwo/ead2as/harvest/oai_marc http://localhost:8080/solr/all/update "solr/all/conf/normalize/prepend_namespace.xsl,solr/all/conf/normalize/iish.archivesspace.marc.xsl,solr/all/conf/import/add.xsl,solr/all/conf/import/addSolrDocument.xsl" "collectionName:iish.archivesspace"
