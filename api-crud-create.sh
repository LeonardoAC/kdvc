#!/bin/sh
#
# LEONARDO A CARRILHO
# 2020 March/April
# INSERT DATA INTO TABLE
#
# SYNTAX: api-crud-create.sh "table name:str" "tb fields:str" "values: str"

# Seta as constantes - nomes auto explicáveis
USERROLE="leonardo"
LOCATION="localhost"
DBNAME="db_kdvc"

# variaveis recebem argumentos do controlador de rotas
#echo "---> $@"
#qtdeParams=$#
tb_name="$1"
tb_fields="$2"
tb_values="$3"
QRY=""

#echo "fields $tb_fields"
#echo "values $tb_values"

# Checa se todos os argumentos obrigatorios foram passados.
if [ ! -z "$tb_name" ] && [ ! -z "$tb_fields" ] && [ ! -z "$tb_values" ]; then
	# Insere o novo user
	# Obs: nao esquecer o parametro -t que facilita a saida para a variavel (exclui o texto excedente)
	userID=$( psql -U $USERROLE -h $LOCATION -d $DBNAME -t -A -c "INSERT INTO $tb_name ( $tb_fields ) VALUES ( $tb_values ) RETURNING user_id;" )
	# Monta o nome da tabela do novo user, no modelo: "tb_contact_user ID)"
	tb_contact_fresh_userID="tb_contact_"$(echo $userID | cut -d ' ' -f 1)
  # monta o comando de execucao do Postgresql
	QRY="CREATE TABLE $tb_contact_fresh_userID (
			user_id SERIAL PRIMARY KEY,
			contact_id int,
      contact_status int
	)"
  # Executa
	output=$( psql -U $USERROLE -h $LOCATION -d $DBNAME -c "$QRY"; )
	# Armazena o insert em um log
	echo "[" $(date) "] "$output" "$tb_contact_fresh_userID >> log-api-crud-create
	# Exibe o resultado de uma forma mais digerivel
  [[ $output == "CREATE TABLE" ]] && output="User criado." || output="Erro no login."
	/bin/sh api-response.sh '{"sessid":"", "msg":"'"$output"'", "data":""}'
	# Close connection to DB
	#psql \q
else
	# Exibe mensagem de erro
	/bin/sh api-response.sh '{"sessid":"", "msg":"ERROR The correct syntax is: <tb_name:str> <tb_fields:str> <tb_values:str>", "data":""}'
fi
