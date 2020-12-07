#!/bin/sh
# ------------------------------
# LEONARDO A CARRILHO
# 2020 march
# Create all Tables
# ------------------------------


# Connection data
USERROLE="leonardo"
LOCATION="localhost"
DBNAME="db_kdvc"
PORT="5432"

function funCreateTables(){
# Create the tables
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

qry2="CREATE TABLE if not exists tb_action (
	action_id SERIAL PRIMARY KEY,
	action_type varchar(10),
	action_status char
)"

qry3="CREATE TABLE if not exists tb_photo (
	photo_id SERIAL PRIMARY KEY,
	user_id int,
	photo_index int,
	photo_uri varchar(100),
	photo_status char,
	FOREIGN KEY (user_id) REFERENCES tb_user (user_id) ON DELETE CASCADE
)"

qry4="CREATE TABLE if not exists tb_position (
	position_id SERIAL PRIMARY KEY,
	user_id int,
	position_lat varchar(15),
	position_lon varchar(15),
	FOREIGN KEY (user_id) REFERENCES tb_user (user_id) ON DELETE CASCADE
)"

# Store all queries into array
declare -a arrQries
arrQries=("$qry1" "$qry2" "$qry3" "$qry4")
lengthArray=${#arrQries[@]}

# Display on screen to Programmer
clear
echo "Building tables..."

# Connect to Postgresql and create the tables
for(( i=0; i<=$lengthArray; i++ )){
	arrOutput=$( psql -U "$USERROLE" -h "$LOCATION" -p "$PORT" -d "$DBNAME" -c "${arrQries[$i]};" )
	#echo "${arrQries[$i]}"
}
echo "it's done [Create tables]."
} #end function


function funDeleteTables(){
# Delete tables
declare -a arrTableNames
arrTableNames=("tb_user" "tb_action" "tb_photo" "tb_position")
for (( i=0; i<${#arrTableNames[@]}; i++ )){
	psql -U "$USERROLE" -h "$LOCATION" -p "$PORT" -d "$DBNAME" -c "DROP TABLE IF EXISTS ${arrTableNames[$i]} CASCADE;"
}
# Delete all tables tb_contact_<id>
for (( i=1; i<100; i++ )){
	psql -U "$USERROLE" -h "$LOCATION" -p "$PORT" -d "$DBNAME" -c "DROP TABLE IF EXISTS tb_contact_$i CASCADE;"
}
echo "it's done [Delete]."
} #end funtion


function funMenu(){
clear
echo "------------------------------------------"
echo " 1 - Create tables [if not  exists]"
echo " "
echo " 5 - Delete ALL tables [if exists]"
echo " "
echo " 9 - SAIR"
echo " "
echo "------------------------------------------"
echo -n " CHOICE:  "
read key
case $key in
	"1")
		funCreateTables
	;;
	"5")
		funDeleteTables
	;;
	"9")
		clear
		echo "It's done!"
		break
	;;
	*)
		funMenu
	;;
esac
} # end function

################## I N I C I O #############
funMenu
