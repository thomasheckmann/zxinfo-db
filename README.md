# zxinfo-db
This is a quick-start guide for getting up and running with your own instance of ZXDB by Einar Saukas, using MariaDB and Docker.

## Requirements
You will need the following to get the container up and run:
* Docker (Windows, Mac or Linux)
* ZXDB SQL script, must be named ZXDB_mysql.sql from Github [ZXDB](https://github.com/zxdb/ZXDB/archive/master.zip)

# Installation
Prepare database script: You need to add the following line as the first in the database script, in order to correct import the data.
````
SET character_set_client = 'utf8';
````

Build the Docker image with
````
docker build . -t zxinfo_db:1.0 
````

Start the mariaDB server instance
````
docker run --name zxdb -p 3306:3306 -v $PWD/mariadb:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d zxinfo_db:1.0
````
Where *my-secret-pw* is the password to be set for the MySQL root user
A docker container with the name *zxdb* should now be running on localhost port 3306.

NOTE: If you updgrade with a new release of ZXDB, remember to remove the mariadb folder, as the script will only be run when MariaDB is initialized.

You can test the instance using (you might have to wait for data to be loaded)
````
docker exec -i zxdb mysql -uroot -p<my-secret-pwd> zxdb -e "select * from hosts;"
````
Where *my-secret-pw* is the password used above.

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
