#!/bin/sh
# -------------------------------------------------
# Leonardo A Carrilho
# 2020, September
# Route ip-number:port/contact/login
#
# Verifica se user existe: POST
#
# -------------------------------------------------
#echo "Content-Type: text/html"
#echo "Content-Type: application/json"
#echo "Access-Control-Allow-Origin: *"
#echo

# Verifica qual o verbo passado pela URL
# Verify what the verb was send from URL
TYPEREQUEST=$REQUEST_METHOD

function funcExtractParamAndSanitize(){
	# OBS: It was installed "jq" to parse Json
	id=$(echo ${1} | jq -r '.id')
	passw=$(echo ${1} | jq -r '.pass')
	name=$(echo ${1} | jq -r '.name')
}


### GET
if [ $TYPEREQUEST == "GET" ]; then
	# return error message
	/bin/sh api-response.sh "Inappropriate method GET."
fi

### POST
if [ $TYPEREQUEST == "POST" ]; then
	#echo "metodo post"
	PARAM="$(cat)"
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		/bin/sh api-response.sh "Params not found."
	else
		funcExtractParamAndSanitize "$PARAM"

		# Monta os argumentos para passar ao script que manuseará o BD
		tb_name=tb_user
		fields="user_login, user_passwd, user_name"
		values=" "''"'$id'"''", "''"'$passw'"''", "''"'$name'"''" "

		# Send to script that will make the job with Postgresql!
		# argumments: nome da tabela, campos para a qry, valores, codigo da consulta a ser feita (vide api-crud-read.sh)
		/bin/sh api-crud-read.sh "$tb_name" "$fields" "$values" "2"
		#echo "$tb_name" "$fields" "$values"
		# Exit this script
		exit 0
	fi
fi

# Json example, to testing in Postman
#{
#  "id":"nonato",
#  "pass":"non123",
#  "name":"Nonato",
#}
