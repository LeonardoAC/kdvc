#!/bin/sh
# -------------------------------------------------
# Leonardo A Carrilho
# 2020, September
# Route ip-number:port/contact/login
#
# Verifica se o user existe: GET
# Verifica credenciais de acesso: POST
#
# -------------------------------------------------

# Check which the verb was send to URL
TYPEREQUEST=$REQUEST_METHOD
msgParamNotFound='{"sessid":"", "msg":"PARAM NOT FOUND", "data":""}'

function funcExtractParamAndSanitize(){
	# OBS: It was installed "jq" to parse Json
	id=$(echo ${1} | jq -r '.data.id')
	passw=$(echo ${1} | jq -r '.data.pass')
}

### GET
if [ $TYPEREQUEST == "GET" ]; then
	PARAM=$QUERY_STRING
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		/bin/sh api-response.sh "$msgParamNotFound"
	else
		legthOfParam=${#PARAM} # Recebe o string length
    userid=${PARAM:3:${legthOfParam}}
    /bin/sh api-crud-read.sh "tb_user" "user_login" "$userid" "3"
		#/bin/sh api-response.sh '{return":"'$userid'"}' #debug
	fi #else
fi

### POST
if [ $TYPEREQUEST == "POST" ]; then
	#echo "metodo post"
	PARAM="$(cat)"
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		/bin/sh api-response.sh "$msgParamNotFound"
	else
    #echo $PARAM
    funcExtractParamAndSanitize "$PARAM"

		# Monta os argumentos para passar ao script que manuseará o BD
		tb_name=tb_user
		fields="user_login, user_passwd, user_name"
		values=" "''"'$id'"''", "''"'$passw'"''" "

		# Send to script that will make the job with Postgresql!
		# argumments: nome da tabela, campos para a qry, valores, codigo da consulta a ser feita (vide api-crud-read.sh)
		/bin/sh api-crud-read.sh "$tb_name" "$fields" "$values" "2"
		#echo "$tb_name" "$fields" "$values"
		# Exit this script
		exit 0
	fi
fi
