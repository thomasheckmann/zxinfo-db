# Re-create ZXINFO database

* Download latest SQL for ZXDB
* Import SQL into MariaDB
* Create JSON documents & import into Elasticsearch
* Create title suggestions
* Test ZXInfo application

# Refresh (zxinfo-db)
````
Download 'ZXDB-latest-generic.sql'
Add SET character_set_client = 'utf8'; to sql file
rm -rf mariadb
docker build . -t zxinfo_db:1.0
docker run --name zxdb -p 3306:3306 -v $PWD/mariadb:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=zxdb1234 -d zxinfo_db:1.0
````

# Start ES - (zxinfo-app)
````
docker-compose --file docker-compose-alpine.yaml run --service-ports -d zxinfo-es-alpine
````
TO clean ALL indexes
````
curl -XDELETE 'http://localhost:9200/_all'
````

# Rebuild ES documents
(a)
````
node create-zxinfo-documents.js -all && (cd ZXInfoArchive/scripts && ./createGameIndex.sh)
````
NEW WINDOW
````
node import-into-elastic.js data/processed/json/
````

## Update screens
````
(cd UpdateScreens && ./getscreens.sh && php convert.php) && node update-new-screens.js UpdateScreens/json/
````
COPY UpdateScreens/zxdb to HTMLROOT

## Update TOSEC refs
````
node create-tosec-references.js TOSEC/XML/ data/processed/tosec/ && node update-tosec-references.js data/processed/tosec/
````

## Create Title suggestions
````
(cd ZXInfoArchive/scripts/ && ./createSuggestersIndex.sh) && node create-title-suggestions.js
````

NOW GO BACK TO (a) and PRESS 'space' to activate new INDEX

# Starting local test
zxinfo-app
	NODE_ENV=development nodemon --ignore public/javascripts/config.js

zxinfo-service
	NODE_ENV=development PORT=8300 nodemon --ignore public/javascripts/config.js

LAUNCH ZXInfo - http://localhost:3000/#!/home

# Moving to LIVE
zxinfo-es
````
tar zcvf data.tgz data/ UpdateScreens/json
copy to HOST
````

zxinfo-es - copy 
````
UpdateScreens/zxdb to HOST/HTMLROOT
````

On HOST

````
cd 'zxinfo-es'
tar zxvf data.tgz
(cd ZXInfoArchive/scripts && ./createGameIndex.sh)
````
NEW WINDOW
````
node import-into-elastic.js data/processed/json/ && node update-tosec-references.js data/processed/tosec/ && node update-new-screens.js UpdateScreens/json/ 
````