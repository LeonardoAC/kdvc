#!/bin/sh
#
# LEONARDO A CARRILHO
# 2020 March/April
# INSERT DATA INTO TABLE
#
# **************************************************************************
#	ATENCAO: O cross origin e o echo vazio abaixo
# nao podem ser retirados sobre pena de nao funcionar corretamente.
# Todo arquivo que irá gerar o resultado para frontend precisa ter o CORS.
# **************************************************************************
echo "Access-Control-Allow-Origin: *"
echo
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

#echo "fields $tb_fields"
#echo "values $tb_values"

# Checa se todos os argumentos obrigatorios foram passados.
if [ -z $tb_values ] || [ -z $tb_fields ]; then
	# Exibe mensagem de erro
	echo "ERROR The correct syntax is: 'tb_name:str' 'tb_fields:str' 'tb_values:str' "
else
	# Executa a query
	QRY="INSERT INTO $tb_name ( $tb_fields ) VALUES ( $tb_values ) RETURNING user_id"

	# Executa a query

	if [ $tb_name == "tb_user" ]; then
		# This option will deploy a new table for the newest user
		# Obs: nao esquecer o parametro -t que facilita a saida para a variavel (exclui o texto excedente)

		varID=$(psql -U $USERROLE -h $LOCATION -d $DBNAME -t -c "$QRY;")

		# Recebe apenas o ID limpo (sem os restos de texto)
		tb_contact="tb_contact_"$(echo $varID | cut -d ' ' -f 1)

		QRY1="CREATE TABLE $tb_contact (
			contact_id SERIAL PRIMARY KEY,
			user_id int,
			contact_permit int,
			contact_block int,
			contact_wait int,
			FOREIGN KEY (user_id) REFERENCES tb_user (user_id) ON DELETE CASCADE
		)"
		# monta o comando de execucao do Postgresql
		output=$(psql -U $USERROLE -h $LOCATION -d $DBNAME -c "$QRY1;")
		# Armazena o insert em um log
		echo "[" $(date) "] " $QRY > log-api-crud-create
		# Execute the query - If Ok, show: CREATE TABLE in API test
		echo $output
	else
		# Execute the query
		psql -U $USERROLE -h $LOCATION -d $DBNAME -c "$QRY;"
	fi

	# Close connection to DB
	psql \q
fi
