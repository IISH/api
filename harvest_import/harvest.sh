#!/bin/bash

# Harvest
dataset=$1
if [ "$dataset" == "" ];
then
    echo "A dataset is needed to harvest.";
    exit 1
fi

cd /data/solr-mappings.index0/harvest_import
d=/data/datasets/$dataset
mkdir -p $d
ln -s $d

  # Write the desired harvest from parameter
  now=$(date +"%Y-%m-%d")
  php LastHarvestFile.php "$now" "-10 day" "$d"/last_harvest.txt

f=$d/catalog.xml
# Any process older than 3 days we assume has a problem. We remove the file.
find $f -mtime 3 -exec rm {} +
if [ -f $f ];
then
	echo "Already processing... ${f}"
	exit 1
fi

php harvest_oai.php $dataset > /data/log/$dataset.$now.harvest.log

  # Import all records
  # For this we need stylesheets to normalize the marc documents into our model
  app=/data/solr-mappings.index0/solr/lib/import-1.0.jar
  java -cp $app org.socialhistory.solr.importer.BatchImport $f "http://localhost:8080/solr/all/update" "/data/solr-mappings.index0/solr/all/conf/normalize/$dataset.xsl,/data/solr-mappings.index0/solr/all/conf/import/add.xsl,/data/solr-mappings.index0/solr/all/conf/import/addSolrDocument.xsl" "collectionName:$dataset"

  rm $f

wget -O /dev/null "http://localhost:8080/solr/all/update?commit=true"
