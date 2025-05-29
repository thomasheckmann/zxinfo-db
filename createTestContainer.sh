#!/bin/bash
#
# Creates docker image with ZXDB version supplied as argument.
# This script extend ZXDB DB structure with a version table, containg only one row with version as input.
#
# BROWSE github/ZXDB/ZXDB to get correct version and note version e.g. 1.0.79
# ! Also update ZXDB_help_search.sql if required !
# Download ZXDB_mysql.sql and save as ZXDB_mysql_1.0.79.sql
# Build docker images: createZXDBcontainer.sh 1.0.79
#

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "usage: createZXDBcontainer.sh <zxdb_version> - check github/ZXDB for available versions"
    exit
fi

ZXDBv=$1

ZXDB_FILE="ZXDB_mysql_$ZXDBv.sql"
echo "Using file: " $ZXDB_FILE

if [[ ! -f $ZXDB_FILE ]] ; then
    echo "File ${ZXDB_FILE} is not there, aborting."
    exit
fi

echo "Creating ZXDB_mysql.sql for version: "$ZXDBv


echo "-- version: $ZXDBv" > ZXDB_mysql.sql
cat ZXDB_mysql_$ZXDBv.sql >> ZXDB_mysql.sql

echo "USE zxdb;" > ZXInfoExt/02_zxdb_version.sql
echo "CREATE TABLE zxdb.zxinfo_version ( version VARCHAR(16) NOT NULL );" >> ZXInfoExt/02_zxdb_version.sql
echo "INSERT INTO zxinfo_version (version) VALUES ('$ZXDBv');" >>ZXInfoExt/02_zxdb_version.sql

if [ -d "mariadb_$ZXDBv" ]; then rm -Rf mariadb_$ZXDBv; fi

mkdir mariadb_$ZXDBv
docker build . -f Dockerfile.test -t zxinfo_db:$ZXDBv
docker stop zxdb_$ZXDBv
docker rm zxdb_$ZXDBv
docker run --name zxdb_$ZXDBv -p 3306:3306 -v $PWD/mariadb_$ZXDBv:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=zxdb1234 -d zxinfo_db:$ZXDBv

echo "Starting phpadmin...."
echo "docker run --name myadmin -d --link zxdb_$ZXDBv:db -p 8080:80 phpmyadmin/phpmyadmin"
docker run --name myadmin -d --link zxdb_$ZXDBv:db -p 8080:80 phpmyadmin/phpmyadmin
echo "http://localhost:8080/"

