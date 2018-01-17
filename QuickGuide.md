# Re-create ZXINFO database

* Download latest SQL for ZXDB
* Import SQL into MariaDB
* Create JSON documents & import into Elasticsearch
* Create title suggestions
* Test ZXInfo application

# Refresh (zxinfo-db)
To create a new and fresh ZXDB instance including TOSEC info:
````
Download 'ZXDB-latest-generic.sql'
Add this line to sql file
SET character_set_client = 'utf8';

Stop and remove ZXDB
docker stop zxdb && docker rm zxdb && rm -rf mariadb

Build:
docker build . -t zxinfo_db:2.0
docker run --name zxdb -p 3306:3306 -v $PWD/mariadb:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=zxdb1234 -d zxinfo_db:2.0
````

# Start ES - (zxinfo-app)
````
docker-compose run --service-ports -d zxinfo-es-alpine
````
TO clean ALL indexes
````
curl -XDELETE 'http://localhost:9200/_all'
````

# Rebuild ES documents
(a)
````
# clean-up
find data/processed/ -type f -name "*.json" -exec rm -rf {} \;
node create-zxinfo-documents.js -all 2> zxscreens.txt && (cd ZXInfoArchive/scripts && ./createGameIndex.sh)
````
NEW WINDOW
````
node import-into-elastic.js data/processed/json/
````

## Update screens
````
# clean-up
[rm -r ./UpdateScreens/zxdb/sinclair/entries/*]
[find ./UpdateScreens/zxscreens ! -path ./UpdateScreens/zxscreens -type d -exec rm -rf {} \;]
find UpdateScreens/json/ -type f -name "*.json" -exec rm -rf {} \;
(cd UpdateScreens && ./getscreens.sh && php convert.php) && node update-new-screens.js UpdateScreens/json/
````
COPY UpdateScreens/zxdb to HTMLROOT
COPY UpdateScreens/zxscreens to HTMLROOT

## Create Title suggestions
````
(cd ZXInfoArchive/scripts/ && ./createSuggestersIndex.sh) && node create-title-suggestions.js
````

NOW GO BACK TO (a) and PRESS 'space' to activate new INDEX

# Starting local test

````
zxinfo-neo4j (in zxapp-app)
	docker-compose --file docker-compose-alpine.yaml run --service-ports -d zxinfo-neo4j

zxinfo-app
	NODE_ENV=development nodemon --ignore public/javascripts/config.js

zxinfo-service
	NODE_ENV=development PORT=8300 nodemon --ignore public/javascripts/config.js
````

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
UpdateScreens/zxscreens to HOST/HTMLROOT
````

On HOST - zxinfo-es

````
cd 'zxinfo-es'

find data/processed/ -type f -name "*.json" -exec rm -rf {} \;
find UpdateScreens/json/ -type f -name "*.json" -exec rm -rf {} \;

tar zxvf data.tgz
(cd ZXInfoArchive/scripts && ./createGameIndex.sh)
````
NEW WINDOW
````
node import-into-elastic.js data/processed/json/ && node update-tosec-references.js data/processed/tosec/ && node update-new-screens.js UpdateScreens/json/ 
````
