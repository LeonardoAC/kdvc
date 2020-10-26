#!/bin/sh
#
# LEONARDO ALVES CARRILHO
# 2020 April
# DELETE RECORD
#
# **************************************************************************
#	ATENCAO: O cross origin e o echo vazio abaixo
# nao podem ser retirados sobre pena de nao funcionar corretamente.
# Todo arquivo que irá gerar o resultado para frontend precisa ter o CORS.
# **************************************************************************
echo "Access-Control-Allow-Origin: *"
echo
#
# Seta as variáveis - nomes auto explicáveis
USERROLE="leonardo"
LOCATION="localhost"
DBNAME="db_kdvc"

tb_name=$1
field=$2
value=$3

QRY="DELETE FROM $tb_name WHERE $field = $value"

# Executa a query
psql -U $USERROLE -h $LOCATION -d $DBNAME -c "$QRY;"
