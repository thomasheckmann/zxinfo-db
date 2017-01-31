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
FROM mariadb:10.1.21

# Install script
COPY ZXDB_latest_generic.sql /docker-entrypoint-initdb.d/00_zxdb_init.sql
