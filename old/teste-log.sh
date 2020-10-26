#!/bin/sh
# --------------------------
# Leonardo A Carrilho
# Marco de 2020
# API para testar a rota
# --------------------------
echo "Content-type: text/html"
echo ""


# Grava um log de data (teste)
echo $(date) >> teste

echo "<!DOCTYPE html>"
echo "<head>
echo "<title>Teste CGI uh-hu</title>"
echo </head>"

echo "<body>"
echo "<h1>Oi Mundo</h1>"
echo "<p>Le log:</p>"
echo "<textarea cols='60' rows='35' style='overflow:scroll;'>"
cat teste
echo </textarea>
echo "</body>"
echo "</html>"

exit 0
