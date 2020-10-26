#!/bin/sh
# -------------------------------------
# Leonardo A Carrilho
# 2020 October, 25
# Create session file in the server
# -------------------------------------
#
PATH="session/"
ID=$1
FILENAME="SESS_"$ID
# Check if file exists
if [[ -z "$PATH$FILENAME" ]];
then
  # create
  touch $PATH$FILENAME
else
  # echo "session file already exists"
  echo "${date} = $PATH$FILENAME already exists" > logs/session_log
fi

# exit
exit 0
