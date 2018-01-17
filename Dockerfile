#
# zxdb Dockerfile
#
# Creates MariaDB container populated with data from ZXDB
#
# Requires ZXDB script ZXDB_latest_genric.sql
#
# https://github.com/....
#

# Pull base image.
FROM mariadb:10.3.3

# Install script
COPY ZXDB_latest_generic.sql /docker-entrypoint-initdb.d/00_zxdb_init.sql

COPY TOSEC/01_import_tosec.sql /docker-entrypoint-initdb.d/01_import_tosec.sql
COPY TOSEC/TOSEC_08_11_2017.txt /docker-entrypoint-initdb.d/TOSEC_08_11_2017.txt


