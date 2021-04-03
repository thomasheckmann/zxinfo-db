# zxinfo-db
This is a quick-start guide for getting up and running with your own instance of ZXDB by Einar Saukas, using MariaDB and Docker.

## Requirements
You will need the following to get the container up and run:
* Docker (Windows, Mac or Linux)
* ZXDB SQL script from Github [ZXDB](https://github.com/zxdb/ZXDB/archive/master.zip)

# Installation
Download ZXDB\_mysql.sql at [ZXDB](https://github.com/zxdb/ZXDB/) - and note the version of the file, let us assume **1.0.81** for this guide.

Save the file as ZXDB\_mysql\_&lt;version&gt;.sql - for example **ZXDB_mysql_1.0.81.sql**

Build the Docker image with supplied script: **createZXDBcontainer.sh &lt;version&gt;**
````
./createZXDBcontainer.sh 1.0.81
````
The script will build and run a mariaDB instance with ZXDB named zxdb\_&lt;version&gt; - in this case **zxdb_1.0.81** and well as myPhpAdmin

Check docker logs - to ensure it has been started and populated correctly.

Now point your browser to http://localhost:8080/ and login with the credential used above.
Default password is _zxdb1234_ strongly recommended to change it after wards :-)

# External references
* [mariaDB on Docker Hub](https://hub.docker.com/_/mariadb/)
* [Using mariaDB via Docker](https://mariadb.com/kb/en/mariadb/installing-and-using-mariadb-via-docker/)
* [Database model ZXDB on Github](https://github.com/zxdb/ZXDB)
