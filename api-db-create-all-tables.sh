#!/bin/sh
# ------------------------------
# LEONARDO A CARRILHO
# 2020 march
# Create all Tables
# ------------------------------

qry1="CREATE TABLE if not exists tb_user (
	user_id SERIAL PRIMARY KEY,
	user_login varchar(50),
	user_passwd varchar(50), 
	user_name varchar(50),
	user_surname varchar(50),
	user_birth varchar(10), 
	user_gender char, 
	user_gender_pref char, 
	user_photo text,
	user_privilege char,
	user_dt_signup varchar(10),
	user_ip_signup varchar(20),
	user_position_signup varchar(20),
	user_dt_signin varchar(10),
	user_ip_signin varchar(20),
	user_position_signin varchar(20)
)"

# Esta table abaixo deverá ser criada automaticamente após a criacao de cada user.
# O nome é: "tb_contact_<id>" onde ID é o user_id da table "tb_user".
# Não será criada junto das demais tabelas, no deploy do APP.
#qry2="CREATE TABLE if not exists tb_contact_<user_id> (
#	contact_id SERIAL PRIMARY KEY,
#	user_id int,
#	contact_permitt varchar(50),
#	contact_blocked varchar(50),
#	contact_waiting varchar(50),
#	FOREIGN KEY (user_id) REFERENCES tb_user (user_id) ON DELETE CASCADE
#)"

qry3="CREATE TABLE if not exists tb_action (
	action_id SERIAL PRIMARY KEY,
	action_type varchar(10),
	action_status char
)"

qry4="CREATE TABLE if not exists tb_photo (
	photo_id SERIAL PRIMARY KEY,
	user_id int, 
	photo_index int,
	photo_uri varchar(100),
	photo_status char,
	FOREIGN KEY (user_id) REFERENCES tb_user (user_id) ON DELETE CASCADE
)"

qry5="CREATE TABLE if not exists tb_position (
		
)"

# Store all queries into array
declare -a arrQries
arrQries=("$qry1" "$qry2" "$qry3" "$qry4" "$qry5")

$USERROLE="leonardo"
$LOCATION="localhost"
$DBNAME="db_kdvc"
$PORT="5432"

# Connect to Postgresql and create the tables
for(i=1, i<=5, i++){
	psql -U $USERROLE -h $LOCATION -p $PORT -d $DBNAME -c ${arrQries[$i]} 
} 

# Chama o script para popular as tabelas do sistema ("tb_action" e "tb_user ( com privilegio adm 9)" )
