-- convert \ to / 
-- sed -e 's/\\/\//g' -e 's/;/\'$'\t/g' TOSEC_08_11_2017.csv > TOSEC_08_11_2017.txt

USE zxdb;

SET character_set_client = 'utf8';

-- create table for TOSEC reference import
DROP TABLE IF EXISTS zxdb.tmp_tosec;
CREATE TABLE tmp_tosec (
  zxdb_id int(11) DEFAULT NULL,
  path varchar(250) COLLATE utf8_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- IMPORT tab delimited file
LOAD DATA LOCAL INFILE '/docker-entrypoint-initdb.d/TOSEC_v1_4.txt' INTO TABLE tmp_tosec
       CHARACTER SET UTF8
       FIELDS TERMINATED BY '\t' lines terminated by '\n';
