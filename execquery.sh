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
QRY="$1"
sessionid="$2"

#echo $1
jsonOutput=$( $DBCONNECT -t -c "$QRY"; )
jsonOutput='{"sessid":"'$sessionid'", "msg":"Ok", "data":'$jsonOutput'}'
echo $jsonOutput
