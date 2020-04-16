#!/bin/sh
# -------------------------------------------------
# LEONARDO A CARRILHO
# 2020 April
# Populate tables (insert fake values) 
# for tests 
# ------------------------------------------------

######## Variables, constants and arrays decalrations ##########
#
declare -a arrUser
declare -a arrAction
#declare -a arrPosition
#declare -a arrPhoto
declare -a arrAskForFollow

USERROLE=leonardo
LOCATION=localhost
PORT=5432
DBNAME=db_kdvc

# Will be necessary create tb_contacts_<id> to each user
# where "ID" is the user_id field from tb_user.

############# Array with the new values ###########
#
arrUser=(
"'josefa', 'jos123', 'Josefa', 'Martuzella Coutinho', '10/03/1960', 'f', 'm', 'link-to-photo.jpg', 1, '20/04/2019', '174.35.97.101', '-22.157100', '13/04/2020', '189.90.86.74', '-22.157212'" 
 "'krebera', 'kre123', 'Krebyson', 'Ildevando Siriguela', '10/12/1940', 'm', 'f', 'link-to-photo.jpg', 1, '20/08/2019', '174.35.97.101', '-22.157100', '13/04/2020', '189.90.86.74', '-22.157212'"
 "'nonato', 'non123', 'Nonato', 'Tiburcinio Souza', '03/07/1999', 'm', 'f', 'link-to-photo.jpg', 1, '10/08/2019', '174.35.97.101', '-22.157100', '13/04/2020', '189.90.86.74', '-22.157212'"
 "'serpegildo', 'ser123', 'Serpegildo', 'Karuzzo Tramontina', '10/03/2000', 'm', 'm', 'link-to-photo.jpg', 1, '20/04/2019', '174.35.97.101', '-22.157100', '13/04/2020', '189.90.86.74', '-22.157212'" 
 "'Zigotta', 'zig123', 'Zigotta', 'Matusquela Pereira', '04/11/2005', 'f', 'f', 'link-to-photo.jpg', 1, '05/04/2020', '174.35.97.101', '-22.157100', '13/04/2020', '189.90.86.74', '-22.157212'"
 "'waldernedson', 'wal123', 'Waldernedson', 'Sapopemba Xeroquio', '19/06/2001', 'f', 'm', 'link-to-photo.jpg', 1, '20/01/2020', '174.35.97.101', '-22.157100', '13/04/2020', '189.90.86.74', '-22.157212'" 
)

arrAction=("wink', 1"
 "'kiss', 1"
 "'hug', 1"
 "'touch', 1"
)

############ fields from tables ############
#
# Fields in tb_user
fieldsTb_user="user_login, 
	user_passwd, 
	user_name, 
	user_surname, 
	user_birth, 
	user_gender, 
	user_gender_pref, 
	user_photo, 
	user_privilege, 
	user_dt_signup, 
	user_ip_signup, 
	user_position_signup, 
	user_dt_signin, 
	user_ip_signin, 
	user_position_signin"

# The values will come from arrUser
QRY="INSERT INTO tb_user ($fieldsTb_user) values"

# Fields to the new table tb_contact_<id>:
fieldsTb_contact="user_id int,
	contact_permit int,
	contact_block int,
	contact_wait int,
	FOREIGN KEY (user_id) REFERENCES tb_user (user_id) ON DELETE CASCADE"

########## Insert data into tb_users and create tb_contact_<id> ##############
#
for (( i=0; i<${#arrUser[@]}; i++ )){
	varID=$(psql -U "$USERROLE" -h "$LOCATION" -p "$PORT" -d "$DBNAME" -c "$QRY (${arrUser[$i]}) RETURNING user_id;")
	# Catch user_id returned
	IDreturned=$( echo $varID | cut -d ' ' -f 3 )
	# Create the personal tables "tb_contact_<id's>"
	tb_contact_id="tb_contact_"$IDreturned
	# Query
	psql -U "$USERROLE" -h "$LOCATION" -p "$PORT" -d "$DBNAME" -c "CREATE TABLE IF NOT EXISTS $tb_contact_id ($fieldsTb_contact);"	

	# ----------- DEBUG ------------ 
	#echo "$varID"
	#echo "$tb_contact_id"
	#echo "$QRY (${arrUser[$i]});"
	#echo ${arrUser[$i]}
	#echo "---------------------------------------"
} # end for loop

############ Insert data into aleatories tb_contact_<ID's> ################
#
QRY0="INSERT INTO tb_contact_1 (
	user_id,
	contact_permit,
	contact_block,
	contact_wait
) VALUES (
	1,
	null,
	null,
	2
)"

QRY1="INSERT INTO tb_contact_1 (
	user_id,
	contact_permit,
	contact_block,
	contact_wait
) VALUES (
	1,
	null,
	null,
	3
)"

QRY2="INSERT INTO tb_contact_2 (
	user_id,
	contact_permit,
	contact_block,
	contact_wait
) VALUES (
	2,
	1,
	null,
	null
)"

QRY3="INSERT INTO tb_contact_3 (
	user_id,
	contact_permit,
	contact_block,
	contact_wait
) VALUES (
	3,
	1,
	null,
	null
)"

QRY4="INSERT INTO tb_contact_2 (
	user_id,
	contact_permit,
	contact_block,
	contact_wait
) VALUES (
	2,
	null,
	null,
	3
)"

QRY5="INSERT INTO tb_contact_3 (
	user_id,
	contact_permit,
	contact_block,
	contact_wait
) VALUES (
	3,
	2,
	null,
	null
)"

QRY6="INSERT INTO tb_contact_5 (
	user_id,
	contact_permit,
	contact_block,
	contact_wait
) VALUES (
	5,
	null,
	null,
	2
)"

QRY7="INSERT INTO tb_contact_2 (
	user_id,
	contact_permit,
	contact_block,
	contact_wait
) VALUES (
	2,
	5,
	null,
	null
)"

arrAskForFollow=("$QRY0" "$QRY1" "$QRY2" "$QRY3" "$QRY4" "$QRY5" "$QRY6" "$QRY7")

for (( i=0; i<${#arrAskForFollow[@]}; i++ )){
	psql -U "$USERROLE" -h "$LOCATION" -p "$PORT" -d "$DBNAME" -c "${arrAskForFollow[$i]};"
}
