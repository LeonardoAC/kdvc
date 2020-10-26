#!/bin/sh
# --------------------------
# Leonardo A Carrilho
# Marco de 2020
# API para testar a rota
# --------------------------
echo "Content-type: text/html"
echo ""

echo "<!DOCTYPE html>"
echo "<head>
echo "<title>Teste CGI uh-hu</title>"
echo </head>"

echo "<body>"
echo "<h1>Teste envio por POST</h1>"
echo $(cat)
echo "</body>"
echo "</html>"

exit 0

# Usar https://apitester.com para passar parametros via POST
# https://reqbin.com/
