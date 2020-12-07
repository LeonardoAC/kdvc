#!/bin/sh
#
# LEONARDO ALVES CARRILHO
# 2020, MARCH
# Query
#
# **************************************************************************
#	ATENCAO: O cross origin e o echo vazio abaixo
# nao podem ser retirados sob pena de nao funcionar corretamente.
# Todo arquivo que irá gerar o resultado para o frontend precisa ter o CORS.
# **************************************************************************

# Seta as variáveis - nomes auto explicáveis
USERROLE="leonardo"
LOCATION="localhost"
DBNAME="db_kdvc"

PARAM_TABLENAME=$1 # table name
PARAM_FIELDS=$2 # columns name
PARAM_VALUES=$3 # fields values
PARAM_CODIGO_QRY=$4 # query code
#DBCONNECT="psql -U $USERROLE -h $LOCATION -d $DBNAME"

# Explode values in array
arrValues=($(echo $PARAM_VALUES | tr "," "\n" ))
login="${arrValues[0]}"
senha="${arrValues[1]}"
#echo "${arrValues[0]} ${arrValues[1]}"

#Documentacao:
#A estrutura CASE será responsavel por retornar a qry desejada.
#+----------+----------------------------+------------------------------+
#|  codigo  |           rota             |         query
#+----------+----------------------------+------------------------------+
#| 1        |  contact/login             | Exibe todos users
#| 2        |  contact/login             | Checa credenciais e retorna
#| 3        |  contact/login             | Verifica se user existe
#| 4        |                            |
#+----------+----------------------------+------------------------------+

case $PARAM_CODIGO_QRY in
  1)
    jsonOutput=$( psql -U $USERROLE -h $LOCATION -d $DBNAME -c "select * from $PARAM_TABLENAME order by $PARAM_FIELDS asc"; )
    jsonOutput='{"sessid":"", "msg":"", "data": "'$jsonOutput'" }'
    ;;
  2)
    jsonOutput=$( psql -U $USERROLE -h $LOCATION -d $DBNAME -t -c "select row_to_json(t) from (select user_login, user_passwd, user_name from $PARAM_TABLENAME where user_login=$login and user_passwd=$senha ) t"; )
    if [[ -z $jsonOutput ]]; then
      # Returned empty
      jsonOutput='{"sessid":"", "msg":"Login incorreto", "data": "" }'
    else
      # User and password OK
      # Session create
      /bin/sh session-create.sh "$login" "$senha"
      exit 0
    fi
    # Send message to frontend
    /bin/sh api-response.sh "$jsonOutput"
    exit 0
    ;;
  3)
    jsonOutput=""
    # Verifica se o user já existe. retorna true ou false
    jsonOutput=$( psql -U $USERROLE -h $LOCATION -d $DBNAME -t -c "select $PARAM_FIELDS from $PARAM_TABLENAME where $PARAM_FIELDS like '"$PARAM_VALUES"'; " )
    #/bin/sh api-response.sh '{"":"", "msg":'"$jsonOutput"''', "":""}' #debug
    if [ -z $jsonOutput ]; then
      # User NAO existe
      #/bin/sh api-response.sh '{"return":"false"}'
      /bin/sh api-response.sh "false"
      #curl  -H "Origin: http://127.0.0.1" -H "Access-Control-Request-Method: GET" -m 3 --request GET "127.0.0.1:8000/contact?return=false"
    else
      # User existe
      #/bin/sh api-response.sh '{"return":"true"}'
      /bin/sh api-response.sh "true"
      #curl  -H "Origin: http://127.0.0.1" -H "Access-Control-Request-Method: GET" -m 3 --request GET "127.0.0.1:8000/contact?return=true"
    fi
    ;;
  4)
    # futuramente
    ;;
  *)
    /bin/sh api-response.sh '{"sessid":"", "msg":"Query not defined", "data": "" }'
    ;;
esac
