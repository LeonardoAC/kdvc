#!/bin/sh
# ----------------------
# Leonardo A Carrilho
# 2020, April
#
# Route ip-number:port/contact/contacts
#
# GET: Retorna todos os contatos do user
# POST: Add um novo contato
# PUT: Permite ou bloqueia um contato
# DELETE: Exclui o contato
#
# ----------------------

# Check what verb was passed from URL
TYPEREQUEST=$REQUEST_METHOD
# Mensagens de feedback
msgMethodError='{"sessid":"", "msg":"Inappropriate method '$TYPEREQUEST'", "data":""}'
msgParamNotFound='{"sessid":"", "msg":"PARAM NOT FOUND", "data":""}'
msgUnknownError='{"sessid":"", "msg":"Erro desconhecido", "data":""}'

function funcExtractParamAndSanitize(){
  # OBS: It was installed "jq" to parse Json
  name=$(echo ${1} | jq -r '.data.name')
  surname=$(echo ${1} | jq -r '.data.surname')
  login=$(echo ${1} | jq -r '.data.email')
  birth=$(echo ${1} | jq -r '.data.born')
  passwd=$(echo ${1} | jq -r '.data.pass')
  rpasswd=$(echo ${1} | jq -r '.data.repass')
  # Perfil completo - UPDATE
  gender=$(echo ${1} | jq -r '.data.gender')
  gender_pref=$(echo ${1} | jq -r '.data.genderp')
  photo=$(echo ${1} | jq -r '.data.photo')
  #privilege=$(echo ${1} | jq -r '.data.privilege')
  #dt_signup=$(echo ${1} | jq -r '.data.')
  #ip_signup=$(echo ${1} | jq -r '.data.')
  #position_signup=$(echo ${1} | jq -r '.data.')
  #dt_signin=$(echo ${1} | jq -r '.data.')
  #ip_signin=$(echo ${1} | jq -r '.data.')
  #position_signin=$(echo ${1} | jq -r '.data.')
}

### GET
if [ $TYPEREQUEST == "GET" ]; then
  PARAM=$QUERY_STRING
  # Check if URL carry params or not
	if [ -z $PARAM ]; then
		# No params
		/bin/sh api-response.sh "$msgParamNotFound"
	else
    # Separa os argumentos em array
    sizeOfParam=${#PARAM}
		id=${PARAM:3:1} # TOMAR CUIDADO COM O LENGTH DO ID
    sessid=${PARAM:10:$sizeOfParam} # TOMAR CUIDADO COM O LENGTH DE CARACTERES NA URL QUE PRECEDEM O ultimo parametro
    # Query all contacts from that id
    QRY="Select array_to_json(array_agg(t)) from (select contact_id as id, contact_status as status from tb_contact_"$id" where user_id = "$id" and contact_status = 0 or contact_status = 1 order by contact_id asc) t"
    /bin/sh execquery.sh "$QRY" "$sessid"
	fi #PARAM
fi

### POST
if [ $TYPEREQUEST == "POST" ]; then
	echo "metodo post"
	PARAM="$(cat)"
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		/bin/sh api-response.sh "Params not found"
	else
		funcExtractParamAndSanitize "I" "$PARAM"
	fi
fi

### PUT
if [ $TYPEREQUEST == "PUT" ]; then
	echo "metodo put"
	PARAM="$(cat)"
	echo $PARAM
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		/bin/sh api-response.sh "Params not found"
	else
		funcExtractParamAndSanitize "I" "$PARAM"
	fi
fi

### PATCH
if [ $TYPEREQUEST == "PATCH" ]; then
	echo "metodo patch"
	PARAM="$(cat)"
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		/bin/sh api-response.sh "Params not found"
	else
		funcExtractParamAndSanitize "I" "$PARAM"
	fi
fi

### DELETE
if [ $TYPEREQUEST == "DELETE" ]; then
	echo "Metodo delete"
	PARAM="$(cat)"
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		/bin/sh api-response.sh "Params not found"
	else
		funcExtractParamAndSanitize "" "$PARAM"
	fi
fi



###### Bibliograph ######
#
# https://bigbinary.com/blog/generating-json-using-postgresql-json-function
# Handling GET params into array: https://stackoverflow.com/questions/3919755/how-to-parse-query-string-from-a-bash-cgi-script
