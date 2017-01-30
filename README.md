# zxinfo-db
This is a quick-start guide for getting up and running with your own instance of ZXDB by Einar Saukas, using MariaDB and Docker.

## Requirements
You will need the following to get the container up and run:
* Docker
* ZXDB generic script, must be named ZXDB_latest_generic.sql from here [LINK]

# Installation
Build the Docker image with
````
docker build . -t zxinfo_db:1.0 
````

Start the mariaDB server instance
````
docker run --name zxdb -v $PWD/mariadb:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d zxinfo_db:1.0
````
Where *my-secret-pw* is the password to be set for the MySQL root user
A docker container with the name *zxdb* should now be running.

You can test the instance using (you might have to wait for data to be loaded)
````
docker exec -i zxdb mysql -uroot -p<my-secret-pwd> zxdb -e "select * from controltypes;"
````
Where *my-secret-pw* is the password used above.