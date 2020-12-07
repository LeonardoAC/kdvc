#!/bin/sh

echo "Access-Control-Allow-Origin: *"
echo "Content-Type: text/Json"
#echo "Content-Type: text/html"
echo

# Seta as variáveis - nomes auto explicáveis
USERROLE="leonardo"
LOCATION="localhost"
DBNAME="db_kdvc"
DBCONNECT="psql -U $USERROLE -h $LOCATION -d $DBNAME"

jsonOutput=$( $DBCONNECT -t -c "$1"; )
echo '{"sessid":"", "msg":"$1", "data":{"'$jsonOutput'"}}'
