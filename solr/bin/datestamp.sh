#!/bin/bash
#
# datestamp.sh
#
# Index individual documents based on their PID
#
# Expected situation is this folder structure:
# /tmp/
# /tmp/datestamp
# /tmp/datestamp/{na}
# /tmp/datestamp/{na}/{file[n]}
#
# Hence the PID is na/file
#
# Lookup via SRU the identifier
# Retrieve the metadata


if [ -z "$API_HOME" ] ; then
    echo "Environmental variable API_HOME not set."
    exit 1
fi


HOTFOLDER="$1"
if [ -z "$HOTFOLDER" ]
then
    HOTFOLDER="/tmp/datestamp"
    echo "No hotfolder was set. Default to ${HOTFOLDER}"
fi

OAI="https://evergreen.iisg.nl/opac/extras/oai/biblio"
SRU="http://api.socialhistoryservices.org/solr/all/srw"


#-----------------------------------------------------------------------------------------------------------------------
# Get the record from the OAI2 service.
#-----------------------------------------------------------------------------------------------------------------------
function oai {
    id="$1"
    dataset="iish.evergreen.biblio"
    oai_call="${OAI}?verb=GetRecord&identifier=oai:evergreen.iisg.nl:${id}&metadataPrefix=marcxml"
    catalog_file="${HOTFOLDER}/${id}.xml"
    wget --no-check-certificate -O "$catalog_file" "$oai_call"

    if [ ! -f "$catalog_file" ]
    then
        echo "Did not find ${catalog_file}"
        exit 1
    else
        php "${API_HOME}/solr/bin/getrecord.php" -f "$catalog_file"
    fi

    app="${API_HOME}/solr/lib/import-1.0.jar"
    java -cp $app org.socialhistory.solr.importer.BatchImport "$catalog_file" "http://localhost:8080/solr/all/update" "${API_HOME}/solr/all/conf/normalize/${dataset}.xsl,${API_HOME}/solr/all/conf/import/add.xsl,${API_HOME}/solr/all/conf/import/addSolrDocument.xsl" "collectionName:$dataset"
    if [[ $? == 0 ]] ; then
        wget "http://localhost:8080/solr/all/update?commit=true"
    else
        subject="Error while indexing: ${catalog_file}"
        echo $subject >> $LOG
        /usr/bin/sendmail --body "$LOG" --from "$MAIL_FROM" --to "$MAIL_TO" --subject "$subject" --mail_relay "$MAIL_HOST"
        exit 1
    fi
}


#-----------------------------------------------------------------------------------------------------------------------
# Get the record from the SRU service.
#-----------------------------------------------------------------------------------------------------------------------
function sru {
  id="$1"
  sru_call="${SRU}?query=marc.852\$p=\"${id}\"&version=1.1&operation=searchRetrieve&recordSchema=info:srw/schema/1/marcxml-v1.1&maximumRecords=1&startRecord=1&resultSetTTL=0&recordPacking=xml"
  tcn=$(python "${API_HOME}/solr/bin/sru_call.py" --url "$sru_call")
  if [ -z "$tcn" ]
  then
      echo "No tcn value found for ${sru_call}"
      exit 1
  else
      echo "${tcn}"
  fi
}


#-----------------------------------------------------------------------------------------------------------------------
# main
#-----------------------------------------------------------------------------------------------------------------------
function main {
    echo "Scanning ${HOTFOLDER}"
    for na in $HOTFOLDER/*
    do
      if [ -d "$na" ]
      then
        for id in $na/*
        do
          id=$(basename $id)
          echo "Found: ${na}/${id}"
          tcn=$(sru "$id")
          oai "$tcn"
        done
      fi
    done
}


main  "$@"