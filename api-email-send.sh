#!/bin/sh
#
#	Leonardo A Carrilho
# 2020 December 18
#
# Send e-mail to users
# Syntax: api-email-send.sh "mailtoAddress" "userID" "userName"
mailTo=$1
id=$2
name=$3
subject="KD?VC Confirmacao de e-mail"
content="Confirmação de e-mail.
$name você recebeu este e-mail porque se cadastrou no KD?VC.
Precisamos que confirme sua inscrição, clicando no link abaixo \n
https://www.kd-vc.com:8000/email/confirm?id=$id \n
Se nao quiser fazer parte desta rede social, ou nao sabe do que se trata, apenas ignore-o. \n
Atenciosamente, \n
Equipe kd-vc. \n
"
#echo -n "$mailTo | $id | $name | $content"
#to="leo_carrilho@hotmail.com, amandaparra86@hotmail.com"

if [[ -z $mailTo || -z $id ]]; then
	echo "param missed"
else
	echo $content | mail -r "kd-vc@kd-vc.com (kd?vc)" -s "$subject" $mailTo
	#echo $content | mail -s "$subject" "$mailTo"
fi


############# Bibliograph ############
#
# https://tecadmin.net/ways-to-send-email-from-linux-command-line/
# https://stackoverflow.com/questions/6537297/how-to-change-sender-name-not-email-address-when-using-the-linux-mail-command
