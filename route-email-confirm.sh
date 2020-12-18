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
echo "Access-Control-Allow-Origin: *"
echo "Content-Type: text/html"
echo

# Check what verb was passed from URL
TYPEREQUEST=$REQUEST_METHOD
# Mensagens de feedback
msgMethodError='{"sessid":"", "msg":"Inappropriate method '$TYPEREQUEST'", "data":""}'
msgParamNotFound='{"sessid":"", "msg":"PARAM NOT FOUND", "data":""}'
msgUnknownError='{"sessid":"", "msg":"Erro desconhecido", "data":""}'

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
		id=${PARAM:3:$sizeOfParam} # TOMAR CUIDADO COM O LENGTH DO ID
    # Query all contacts from that id
    #/bin/sh execquery.sh "$id"
    echo "Param $id"
	fi #PARAM
fi
