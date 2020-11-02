# zxinfo-db
This is a quick-start guide for getting up and running with your own instance of ZXDB by Einar Saukas, using MariaDB and Docker.

## Requirements
You will need the following to get the container up and run:
* Docker (Windows, Mac or Linux)
* ZXDB SQL script from Github [ZXDB](https://github.com/zxdb/ZXDB/archive/master.zip)

# Installation
Download ZXDB\_mysql.sql at [ZXDB](https://github.com/zxdb/ZXDB/) - and note the version of the file, let us assume **1.0.81** for this guide.

Save the file as ZXDB\_mysql\_&lt;version&gt;.sql - for example **ZXDB_mysql_1.0.81.sql**

Build the Docker image with supplied script: **buildZXDB.sh &lt;version&gt;**
````
./buildZXDB.sh 1.0.81
````
The script will build and run a mariaDB instance with ZXDB named zxdb\_&lt;version&gt; - in this case **zxdb_1.0.81**

Check docker logs - to ensure it has been started and populated correctly.

# Manual docker start
Start the mariaDB server instance

<pre>
docker run --name zxdb -p 3306:3306 -v $PWD/mariadb:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=<b>my-secret-pwd</b> -d zxinfo_db:1.0
</pre>

Where **my-secret-pwd** is the password to be set for the MySQL root user
A docker container with the name *zxdb* should now be running on localhost port 3306.

NOTE: If you updgrade with a new release of ZXDB, remember to remove the mariadb folder, as the script will only be run when MariaDB is initialized.

You can test the instance using (you might have to wait for data to be loaded)

<pre>
docker exec -i zxdb mysql -uroot -p<b>my-secret-pwd</b> zxdb -e "select * from hosts;"
</pre>

Where **my-secret-pwd** is the password used above.

# Running myPhpAdmin
If you want to run myPhpAdmin with this Docker container, start the myPhpAdmin with:
````
docker run --name myadmin -d --link zxdb:db -p 8080:80 phpmyadmin/phpmyadmin
````
Now point your browser to http://localhost:8080/ and login with the credential used above.

# External references
* [mariaDB on Docker Hub](https://hub.docker.com/_/mariadb/)
* [Using mariaDB via Docker](https://mariadb.com/kb/en/mariadb/installing-and-using-mariadb-via-docker/)
* [Database model ZXDB on Github](https://github.com/zxdb/ZXDB)
