#!/bin/sh
# --------------------------
# Leonardo A Carrilho
# Marco de 2020
# API para testar a rota
# --------------------------
echo "Content-type: text/html"
echo ""


function pegaParamNaURL(){
	saveIFS=$IFS
	IFS='=&'
	parm=($QUERY_STRING)
	IFS=$saveIFS

	declare -A array
	for ((i=0; i<${#parm[@]}; i+=2))
	do
    		array[${parm[i]}]=${parm[i+1]}
	done

	output="Name: ${array['name']} surname: ${array['surname']}"
}

# Grava um log de data (teste)
echo $(date) >> teste

echo "<!DOCTYPE html>"
echo "<head>
echo "<title>Teste CGI GET</title>"
echo </head>"

echo "<body>"
echo "<h1>Teste vars GET</h1>"
echo "<h4>Teste GET passando url: $SERVER_ADDR:$SERVER_PORT/[nomeDoApp]?name=[valor]&surname=[valor]</h4>"
pegaParamNaURL
echo "saida da funcao: $output"
echo "</body>"
echo "</html>"

exit 0

#######################################################################################################
# parametros na URL fonte: 
#
# https://stackoverflow.com/questions/3919755/how-to-parse-query-string-from-a-bash-cgi-script
# echo "query_string:    $QUERY_STRING"
# echo "request_method:  $REQUEST_METHOD"
# argument=`echo "$QUERY_STRING" | sed "s|name=||"`
# echo "argument:        $argument"
#
#
##################################################################
