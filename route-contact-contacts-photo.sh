#!/bin/sh
# ----------------------
# Leonardo A Carrilho
# 2020, April
# This is the controller
# ----------------------
echo "Content-Type: text/html"
echo

# Verifica qual o verbo passado pela URL
# Verify what verb was passed from URL
TYPEREQUEST=$REQUEST_METHOD

function funcExtractParamAndSanitize(){
	# OBS: It was installed "jq" to parse Json
	#echo "entrou na function $1 $2"
	#
	# Param by POST, PUT, PATCH, DELETE (Internal)
	if [ $1 == "I" ]; then
		#echo Interno
		echo "${2}" | jq '.employees.employee[0].photo'
	#
	# Param by URL - GET (External)
	elif [ $1 == "E" ]; then
		echo Externo
	fi
}


### GET
if [ $TYPEREQUEST == "GET" ]; then
	#echo "metodo get"
	# Check if URL carry params or not
	if [ -z $QUERY_STRING ]; then
		# No params
		echo "URL returns empty"
	else
		funcExtractParamAndSanitize E "$QUERY_STRING"
	fi
fi

### POST
if [ $TYPEREQUEST == "POST" ]; then
	echo "metodo post"
	PARAM="$(cat)"
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		echo "No params found"
	else
		funcExtractParamAndSanitize "I" "$PARAM"
	fi
fi

### PUT
if [ $TYPEREQUEST == "PUT" ]; then
	echo "metdodo put"
	PARAM="$(cat)"
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		echo "No params found"
	else
		funcExtractParamAndSanitize I "$PARAM"
	fi
fi

### PATCH
if [ $TYPEREQUEST == "PATCH" ]; then
	echo "metdodo patch"
	PARAM="$(cat)"
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		echo "No params found"
	else
		funcExtractParamAndSanitize I "$PARAM"
	fi
fi

### DELETE
if [ $TYPEREQUEST == "DELETE" ]; then
	echo "Metodo delete"
	PARAM="$(cat)"
	# Check if return params
	if [ -z "$PARAM" ]; then
		# No params
		echo "No params found"
	else
		funcExtractParamAndSanitize "$PARAM"
	fi
fi



###### Check what route is from
