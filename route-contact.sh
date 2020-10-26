#!/bin/sh
# ----------------------
# Leonardo A Carrilho
# 2020, April
# Route ip-number:port/contact
#
# Cria o user: POST
# Edita user: PUT, UPDATE
# Deleta user: DELETE
#
# ----------------------
echo "Content-Type: text/html"
echo

# Verifica qual o verbo passado pela URL
# Verify what verb was passed from URL
TYPEREQUEST=$REQUEST_METHOD

function funcExtractParamAndSanitize(){
	# OBS: It was installed "jq" to parse Json
	name=$(echo ${1} | jq -r '.name')
	birth=$(echo ${1} | jq -r '.birth')
	gender=$(echo ${1} | jq -r '.gender')
	gender_pref=$(echo ${1} | jq -r '.gender_pref')
	photo=$(echo ${1} | jq -r '.photo')
}


### GET
if [ $TYPEREQUEST == "GET" ]; then
	/bin/sh api-response.sh "Inappropriate method GET."
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
		funcExtractParamAndSanitize "$PARAM"

		# Monta os argumentos para passar ao script que manuseará o BD
		tb_name=tb_user
		fields="user_name, user_birth, user_gender, user_gender_pref, user_photo"
		values=" "''"'$name'"''", "''"'$birth'"''", "''"'$gender'"''", "''"'$gender_pref'"''", "''"'$photo'"''" "

		# Send to script that will make the job with Postgresql!
		/bin/sh api-crud-create.sh "$tb_name" "$fields" "$values"
		# Exit this script
		exit 0
	fi
fi

### PUT
if [ $TYPEREQUEST == "PUT" ]; then
	echo "metdodo put"
	PARAM="$(cat)"
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		/bin/sh api-response.sh "Params not found"
	else
		funcExtractParamAndSanitize "$PARAM"

		# Monta os argumentos para passar ao script que manuseará o BD
		tb_name=tb_user
		fields="user_name, user_birth, user_gender, user_gender_pref, user_photo"
		values=" "''"'$name'"''", "''"'$birth'"''", "''"'$gender'"''", "''"'$gender_pref'"''", "''"'$photo'"''" "

		# Send to script that will make the job with Postgresql!
		/bin/sh api-crud-update.sh "$tb_name" "$fields" "$values"
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
		/bin/sh api-response.sh "Params not found"
	else
		funcExtractParamAndSanitize "$PARAM"
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
		#funcExtractParamAndSanitize "$PARAM"

		# Monta os argumentos para passar ao script que manuseará o BD
		tb_name=tb_user
		fields=user_id
		values=$(echo $PARAM | jq -r '.user_id')

		# Send to script that will make the job with Postgresql!
		/bin/sh api-crud-delete.sh "$tb_name" "$fields" "$values"
		# Exit this script
		exit 0

	fi
fi

#{
#  "name":"Gilvanio Galdencio Chaleiro",
#  "birth":"30/09/1965",
#  "gender":"m",
#  "gender_pref":"f",
#  "photo":"https://izismile.com/img/img11/20180412/640/world_is_full_of_strange_and_weird_people_640_high_44.jpg"
#}
