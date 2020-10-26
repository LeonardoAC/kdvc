#!/bin/sh
# ------------------------------
# LEONARDO ALVES CARRILHO
# February 2020
# ------------------------------
#echo $(date) >> log

function insert(){
# Insercao	
	DBName="db_kdvc"
	TBName="public.tb_login"
	QRY="INSERT INTO $TBName (login_code, login_login, login_password, login_date_signup, login_ip_signup, login_geo_signup, login_status) VALUES (2, '$1', '$2', '$3', '$4', '$5', '1')"
	#psql -U postgres -h localhost -p 5432 -d $DBName -c "INSERT INTO $TBName (login_code, login_login, login_password, login_date_signup, login_ip_signup, login_geo_signup, login_status) VALUES (1, '$1', '$2', '$3', '$4', '$5', '1')"
	psql -U postgres -h localhost -p 5432 -d $DBName -c "$QRY"
}

function checkArguments(){
# Verifica se passou os parametros necessários para não ocorrer erro na insercao
	clear
	flag=0
	if [[ -z $1 ]]; then 
		echo "ERROR 01"
		flag=1
	fi	
	if [[ -z $2 ]]; then 
		echo "ERROR 02"
		flag=1
	fi	
	if [[ -z $3 ]]; then 
		echo "ERROR 03"
		flag=1
	fi	
	if [[ -z $4 ]]; then 
		echo "ERROR 04"
		flag=1
	fi	
	if [[ -z $5 ]]; then 
		echo "ERROR 05"
		flag=1
	fi
	if [ $flag -eq 0 ]; then
		insert $1 $2 $3 $4 $5
	fi
}

checkArguments $1 $2 $3 $4 $5
