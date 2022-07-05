#!/bin/bash

API_ENDPOINT='http://localhost:8080/solr/all/update'
SQL='select id, repo_id  from resource;'
HOST='n-195-169-89-74.diginfra.net'
PASSWORD='13ace1fa-fb83-11ec-b00e-17642db5fe2a'
ID_FILE='/tmp/id.txt'
DOMEIN='https://as-oai.collections.iisg.org'
DATASET='/data/datasets/archivesspace'

/usr/bin/mysql -h "$HOST" -u archivesspace -p"$PASSWORD" -BN -e "$SQL" archivesspace > "$ID_FILE"

for metadata_prefix in oai_ead oai_marc
do
  folder="${DATABASE}/${metadata_prefix}"
  ([ -d "$folder" ] && rm "${folder}/"*) || mkdir "$folder"
  while read -r resource_id repo_id
  do
    identifier="oai:archivesspace//repositories/${repo_id}/resources/${resource_id}"
    url="${DOMEIN}?verb=GetRecord&identifier=${identifier}&metadataPrefix=${metadata_prefix}"
    f="${folder}/${repo_id}_${resource_id}.xml"
    CMD="curl -X GET -o '${f}' -k '$url'"
    echo "$CMD" && eval "$CMD"
    (grep -q "idDoesNotExist" "$f" && echo "BAD ${f} - idDoesNotExist ${identifier} in ${f}" && rm "$f") || echo "OK ${f}"
  done < "$ID_FILE"
done

java -cp "${API_HOME}/solr/lib/import-1.1.0.jar" org.socialhistory.solr.importer.BatchImport "${DATASET}/oai_marc" "$API_ENDPOINT" "${API_HOME}/solr/all/conf/normalize/cleanup.xsl,${API_HOME}/solr/all/conf/normalize/prepend_namespace.xsl,${API_HOME}/solr/all/conf/normalize/iish.archivesspace.marc.xsl,${API_HOME}/solr/all/conf/import/add.xsl,${API_HOME}/solr/all/conf/import/addSolrDocument.xsl" "collectionName:iish.archieven"

curl -X GET "${API_ENDPOINT}?commit=true&optimize=true"