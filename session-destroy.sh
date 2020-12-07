#!/bin/sh
# -------------------------------------
# Leonardo A Carrilho
# 2020 November, 04
# Destroy session file in the server
# -------------------------------------
#
# SYNTAX: session_destroy.sh "user" "passw"
#
path="session/"
user=$1
passw=$2

# Create ID by MD5 (user and password)
ID=$(echo "$user kdvc $passw" | md5sum)
FILENAME="SESS_"$ID

# Check if file exists
if [[ ! -z "$path$FILENAME" ]];
then
  # delete
  rm -f $path$FILENAME
fi

# exit
exit 0
