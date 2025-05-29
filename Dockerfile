#
# zxdb Dockerfile
#
# Creates MariaDB container populated with data from ZXDB and 
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
COPY ZXInfoExt/02_zxdb_version.sql /docker-entrypoint-initdb.d/

COPY ZXInfoExt/TOSEC/01_import_tosec.sql /docker-entrypoint-initdb.d/20_import_tosec.sql
COPY ZXInfoExt/TOSEC/tosec_2020.txt /docker-entrypoint-initdb.d/TOSEC_import.txt

