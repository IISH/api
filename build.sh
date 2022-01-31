#!/bin/bash
#
# build.sh
#
# Combine the harvest_import and solr packages as tar.gz

# Ensure a non zero exit value to break the build procedure in case of a known error.
set -e

instance=$1
if [ -z "$instance" ] ; then
	instance="api"
	echo "Default instance name ${instance}"
fi

version=$2
if [ -z "$version" ] ; then
	version="1.0.0"
	echo "Default version ${version}"
fi

revision=$(git rev-parse HEAD)
app="${instance}-${version}"
target="target/${app}"
expect=$target.tar.gz

echo "Build $expect from revision $revision"
echo $revision > "build.txt"

# Remove previous builds.
if [ -d target ] ; then
	rm -r target
fi

# Move the files to a folder that has the same name as the app
echo "Copy solr files"
rsync -av --progress solr $app
chmod 744 $app/solr/bin/*.sh

# Move the jar
echo "Move the import jar"
rsync -av --progress "import/target/import-"*.jar "solr/lib/"


mkdir target
tar -zcvf $expect $app
rm -rf $app
