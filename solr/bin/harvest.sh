#!/bin/bash
#
# harvest.sh
# Start an OAI2 harvest



#-----------------------------------------------------------------------------------------------------------------------
# See if we have a dataset.
#-----------------------------------------------------------------------------------------------------------------------
dataset=$1
if [ -z "$dataset" ];
then
    echo "A dataset is needed to harvest."
    exit 1
fi

original="$2" # e.g. based on the shared basedir (e in this case): /a/b/c/d/e/f/123.xml and /a/b/c/d/e/g/123.xml theh use value: "../g"

now=$(date +"%Y-%m-%d")
LOG="/data/log/${dataset}.${now}.harvest.log"


#-----------------------------------------------------------------------------------------------------------------------
# Make sure we have a home directory.
#-----------------------------------------------------------------------------------------------------------------------
if [ -z "$API_HOME" ] ; then
    echo "Environmental variable API_HOME not set." > $LOG
    cat $LOG
    exit 1
fi


#-----------------------------------------------------------------------------------------------------------------------
# Enter the (this) bin folder and create a link to the data folder for this dataset.
#-----------------------------------------------------------------------------------------------------------------------
cd "${API_HOME}/solr/bin"
d="/data/datasets/${dataset}"
mkdir -p $d
ln -s $d


#-----------------------------------------------------------------------------------------------------------------------
# Write the desired -from harvest parameter.
#-----------------------------------------------------------------------------------------------------------------------
php LastHarvestFile.php "$now" "-10 day" "$d"/last_harvest.txt


#-----------------------------------------------------------------------------------------------------------------------
# Do not continue if a process is still running for this dataset.
#-----------------------------------------------------------------------------------------------------------------------
catalog_file=$d/catalog.xml
# Any process older than 3 days we assume has a problem. We remove the file.
find $catalog_file -mtime +3 -exec rm {} +
if [ -f $catalog_file ];
then
    subject="Warning while indexing: ${catalog_file}"
	echo "Still processing file... ${catalog_file}">$LOG
    /usr/bin/sendmail --body "$LOG" --from "$MAIL_FROM" --to "$MAIL_TO" --subject "$subject" --mail_relay "$MAIL_HOST"
	exit 1
fi


#-----------------------------------------------------------------------------------------------------------------------
# Start the harvest.
#-----------------------------------------------------------------------------------------------------------------------
php harvest_oai.php $dataset > $LOG


#-----------------------------------------------------------------------------------------------------------------------
# Import all records with the import utility.
#-----------------------------------------------------------------------------------------------------------------------
app=$API_HOME/solr/lib/import-1.0.jar
java -cp $app org.socialhistory.solr.importer.BatchImport "$catalog_file" "http://localhost:8080/solr/all/update" "${API_HOME}/solr/all/conf/normalize/${dataset}.xsl,${API_HOME}/solr/all/conf/normalize/prepend_namespace.xsl,${API_HOME}/solr/all/conf/import/add.xsl,${API_HOME}/solr/all/conf/import/addSolrDocument.xsl" "collectionName:${dataset}"
if [[ $? != 0 ]] ; then
    subject="Error while indexing: ${catalog_file}"
    echo $subject >> $LOG
    /usr/bin/sendmail --body "$LOG" --from "$MAIL_FROM" --to "$MAIL_TO" --subject "$subject" --mail_relay "$MAIL_HOST"
    exit 1
fi


#-----------------------------------------------------------------------------------------------------------------------
# Cleanup the harvested catalog.
#-----------------------------------------------------------------------------------------------------------------------
rm $catalog_file


#-----------------------------------------------------------------------------------------------------------------------
# Commit. Really not neccessary. But we like to be sure all is in the index and not the transaction log.
#-----------------------------------------------------------------------------------------------------------------------
wget -O /dev/null "http://localhost:8080/solr/all/update?commit=true"


exit 0