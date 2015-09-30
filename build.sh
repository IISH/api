#!/bin/bash
#
# build.sh
#
# Combine the harvest_import and solr packages as tar.gz

# Ensure a non zero exit value to break the build procedure.
set -e

instance=$1
if [ -z "$instance" ] ; then
	echo "Need a name of the project build."
	exit -1
fi

version=$2
if [ -z "$version" ] ; then
	version="1.0.0"
	echo "Default version ${version}"
fi

revision=$(git rev-parse HEAD)
app=$instance-$version
target=target/$app
expect=$target.tar.gz

echo "Build $expect from revision $revision"
echo $revision > "build.txt"


# Remove previous builds.
if [ -d target ] ; then
	rm -r target
fi

# Move the files to a folder that has the same name as the app
rsync -av --exclude='analyzers' --exclude='bootstrap' --exclude='import' --exclude='sru' --exclude='widget' --exclude='.git' --exclude='.gitignore' . $app

mkdir target
tar -zcvf $expect $app
rm -rf $app
