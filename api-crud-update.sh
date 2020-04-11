#!/bin/sh
# ----------------------------
# LEONARDO ALVES CARRILHO
# MARCO 2020
# INSERT DATA INTO TABLE
# ----------------------------

# Seta as variáveis - nomes auto explicáveis
USERROLE="leonardo"
LOCATION="localhost"
DBNAME="db_kdvc"

field=$2
newvalue=$3
fieldverif=$4
valueverif=$5

# Array recebe o nome das tables
declare -a arrTABLES
arrTABLE=("tb_login" "tb_user" "tb_contact" "tb_teste" "oimundo")


QRY="UPDATE ${arrTABLE[$1]} SET $field = $newvalue WHERE $fieldverif = $valueverif"

# Executa a query
psql -U $USERROLE -h $LOCATION -d $DBNAME -c "$QRY";
