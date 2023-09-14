#!/bin/bash

version="$1"

# First wait for container to be running
# Error response from daemon: Container 9b698fe86c0cf288f73c1427643151b4bb18f0a7257ec9308d30a3f16d1c8ef9 is not running
# Error: No such container: zxdb_1.0.154

echo "Waiting for mysql to spin up v$version"

response="$(docker exec -i zxdb_$version mysql -uroot -pzxdb1234 zxdb -e "select count(*) from zxinfo_version;" 2>&1 >/dev/null)"
until ! grep -q "No such container" <<< "$response"; do
  printf '.'
  sleep 1
  response="$(docker exec -i zxdb_$version mysql -uroot -pzxdb1234 zxdb -e "select count(*) from zxinfo_version;" 2>&1 >/dev/null)"
done

echo "MySQL is up and running, now waiting for database to be ready..."
sleep 5

# Wait for no access-denied
# ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)

response="$(docker exec -i zxdb_$version mysql -uroot -pzxdb1234 zxdb -e "select count(*) from zxinfo_version;" 2>&1 >/dev/null)"
until ! grep -q "Access denied for user" <<< "$response"; do
  printf '.'
  sleep 1
  response="$(docker exec -i zxdb_$version mysql -uroot -pzxdb1234 zxdb -e "select count(*) from zxinfo_version;" 2>&1 >/dev/null)"
done

echo "Waiting for DB to be populated..."
response="$(docker exec -i zxdb_$version mysql -uroot -pzxdb1234 zxdb -e "select count(*) from zxinfo_version;" 2>&1 >/dev/null)"
until ! grep -q "doesn't exist" <<< "$response"; do
  printf '.'
  sleep 1
  response="$(docker exec -i zxdb_$version mysql -uroot -pzxdb1234 zxdb -e "select count(*) from zxinfo_version;" 2>&1 >/dev/null)"
done

echo "Everything is up and ready to go...."
