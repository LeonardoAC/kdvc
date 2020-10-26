#!/bin/sh
#
# LEONARDO ALVES CARRILHO
# 2020, MARCH
# Query
#
# **************************************************************************
#	ATENCAO: O cross origin e o echo vazio abaixo
# nao podem ser retirados sobre pena de nao funcionar corretamente.
# Todo arquivo que irá gerar o resultado para frontend precisa ter o CORS.
# **************************************************************************
#echo "Access-Control-Allow-Origin: *"
#echo

# Seta as variáveis - nomes auto explicáveis
USERROLE="leonardo"
LOCATION="localhost"
DBNAME="db_kdvc"

PARAM_TABLENAME=$1 # 1 único param
PARAM_FIELDS=$2 # varios
PARAM_VALUES=$3 # varios
PARAM_CODIGO_QRY=$4 # 1 ou 2 characters

arrValues=($(echo $PARAM_VALUES | tr "," "\n" ))
login="${arrValues[0]}"
senha="${arrValues[1]}"
#echo "${arrValues[0]} ${arrValues[1]}"

#Documentacao:
#A estrutura CASE será responsavel por retornar a qry desejada.
#+----------+----------------------------+------------------------------+
#|  codigo  |           rota             |         query
#+----------+----------------------------+------------------------------+
#| 1        |  contact/login             | exibe todos users
#| 2        |  contact/login             | verifica se user existe
#| 3        |
#| 4        |
#+----------+----------------------------+------------------------------+

case $PARAM_CODIGO_QRY in
  1)
    psql -U $USERROLE -h $LOCATION -d $DBNAME -c "select * from $PARAM_TABLENAME order by $PARAM_FIELDS asc";
    ;;
  2)
    jsonOutput=$( psql -U $USERROLE -h $LOCATION -d $DBNAME -t -c "select row_to_json(t) from (select user_login, user_passwd, user_name from $PARAM_TABLENAME where user_login=$login and user_passwd=$senha ) t"; )
    if [[ -z $jsonOutput ]]; then
      # Returned empty
      jsonOutput='{"msg":"Login incorreto :_( "}'
    else
      # There is a user and password OK
      jsonOutput='{"msg":"OK :) "}'
    fi
    /bin/sh api-response.sh "$jsonOutput"
    exit 0
    ;;
  3)
    # futuramente
    ;;

  *)
    echo '"{"msgstatus":"Query not defined"}"'
    ;;
esac
