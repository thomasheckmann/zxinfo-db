#
# zxdb Dockerfile
#
# Creates MariaDB container populated with data from ZXDB
#
# Requires ZXDB script ZXDB_mysql.sql
#
# https://github.com/....
#

# Pull base image.
FROM mariadb:10.4.11

# Install script
COPY ZXDB_mysql.sql /docker-entrypoint-initdb.d/00_zxdb_init.sql
COPY ZXDB_help_search.sql /docker-entrypoint-initdb.d/01_zxdb_help_search.sql

COPY TOSEC/01_import_tosec.sql /docker-entrypoint-initdb.d/20_import_tosec.sql
COPY TOSEC/TOSEC_v1_4.txt /docker-entrypoint-initdb.d/TOSEC_v1_4.txt


