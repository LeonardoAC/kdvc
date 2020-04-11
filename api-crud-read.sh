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

# Array recebe o nome das tables
declare -a arrTABLES
arrTABLE=("tb_login" "tb_user" "tb_contact" "tb_teste" "oimundo")

QRY="select * from ${arrTABLE[$1]} ORDER BY $2 ASC"

# Executa a query
psql -U $USERROLE -h $LOCATION -d $DBNAME -c "$QRY";

