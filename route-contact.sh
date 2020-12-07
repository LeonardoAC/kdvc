#!/bin/sh
# ----------------------
# Leonardo A Carrilho
# 2020, April
# Route ip-number:port/contact
#
# Cria o user: POST
# Edita user: PUT
# Deleta user: DELETE
#
# ----------------------

# Check out what verb was passed from URL
TYPEREQUEST=$REQUEST_METHOD
# Mensagens de feedback
msgMethodError='{"sessid":"", "msg":"Inappropriate method '$TYPEREQUEST'", "data":""}'
msgRePasswdError='{"sessid":"", "msg":"Senhas nao conferem", "data":""}'
msgParamNotFound='{"sessid":"", "msg":"PARAM NOT FOUND", "data":""}'
msgUserAlreadExists='{"sessid":"", "msg":"Usuário já existe", "data":""}'
msgUnknownError='{"sessid":"", "msg":"Erro desconhecido", "data":""}'

function funcCheckIfUserAlreadyExists(){
	USERROLE="leonardo"
	LOCATION="localhost"
	DBNAME="db_kdvc"

	returnFromQuery=$( psql -U $USERROLE -h $LOCATION -d $DBNAME -t -c "select user_login from tb_user where user_login like '$login' "; )
	#/bin/sh api-response.sh '{"sessid":" ", "msg":" '"$returnFromQuery"' ", "data":" "}' #debug
	if [ -z $returnFromQuery ]; then
		userAlreadyExist="false"
	else
		userAlreadyExist="true"
	fi
}

function funcCheckIfBothPasswAreEquals(){
	if [ "$passwd" == "$rpasswd" ]; then
		passwdChecked="true"
	else
		passwdChecked="false"
	fi
}

function funcExtractParamAndSanitize(){
	# OBS: It was installed "jq" to parse Json
	# Usado no prospect - POST
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
	/bin/sh api-response.sh "$msgMethodError"
fi

### POST
if [ $TYPEREQUEST == "POST" ]; then
	PARAM="$(cat)"
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		/bin/sh api-response.sh "$msgParamNotFound"
	else
		funcExtractParamAndSanitize "$PARAM"
		# Monta os argumentos para passar ao script que manuseará o BD
		tb_name="tb_user"
		fields="user_name, user_surname, user_birth, user_login, user_passwd, user_photo"
		values=" "''"'$name'"''", "''"'$surname'"''", "''"'$birth'"''", "''"'$login'"''", "''"'$passwd'"''", "''"'$photo'"''" "

		funcCheckIfUserAlreadyExists
		if [ $userAlreadyExist == "false" ]; then
				funcCheckIfBothPasswAreEquals
				# Check out if both passwords are equals
				if [ $passwdChecked == "true" ]; then
					# Send to script that will make the job with Postgresql!
					/bin/sh api-crud-create.sh "$tb_name" "$fields" "$values"
					#/bin/sh api-response.sh '{"":"","msg":"Sera criado o registro", "":""}' # debug
				else
					# Senhas nao coincidem
					/bin/sh api-response.sh "$msgRePasswdError"
				fi # else
		elif [ "$userAlreadyExist" == "true" ]; then
				# User ja cadastrado no BD
				/bin/sh api-response.sh "$msgUserAlreadExists"
		else
				# Erro desconhecido
				/bin/sh api-response.sh "$msgUnknownError"
		fi
		# Exit this script
		exit 0
	fi # PARAM
fi # $TYPEREQUEST == "POST"

### PUT
if [ $TYPEREQUEST == "PUT" ]; then
	echo "metdodo put"
	PARAM="$(cat)"
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		/bin/sh api-response.sh "$msgParamNotFound"
		# Exit this script
		exit 0
	fi
fi

### PATCH
if [ $TYPEREQUEST == "PATCH" ]; then
	echo "metdodo patch"
	PARAM="$(cat)"
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		/bin/sh api-response.sh "$msgParamNotFound"
		# Exit this script
		exit 0
	fi
fi

### DELETE
if [ $TYPEREQUEST == "DELETE" ]; then
	echo "Metodo delete"
	PARAM="$(cat)"
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		/bin/sh api-response.sh "$msgParamNotFound"
		# Exit this script
		exit 0
	fi
fi
