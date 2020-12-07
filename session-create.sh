#!/bin/sh
# -------------------------------------
# Leonardo A Carrilho
# 2020 October, 25
# Create session file (if not exists) in the server
# -------------------------------------
#
# SYNTAX: session_create.sh "user" "passw"
#
path="session/"
user=$1
passw=$2
secret="vckd"

function checkDirExists(){
  # Check if directory "session" exists. If not then create it.
  if [[ ! -d "session" ]];
  then
    mkdir "session"
  fi
}

function convertMD5(){
  # Encrypt session ID by MD5 (user and password plus a secret word)
  ID=$( echo $user$secret$passw | md5sum )
  ID=${ID:0:32} # return the first 32 characters
  FILENAME="SESS_"$ID
}

function checkExistsSESS_ID(){
  # Check if file exists
  if [[ ! -z $path$FILENAME ]];
  then
    # create Session file
    touch $path$FILENAME
    # return ID session
    /bin/sh api-response.sh '{"sessid":"'"$ID"'", "msg":"Login OK", "data":"" }'
  else
    # echo "session file already exists"
    echo 1
  fi
  # exit
  exit 0
}

# At first, the arguments need exists
if [[ -z $user || -z $passw ]];
then
  # get system date
  data=$(date +"%Y-%m-%d %T" )
  # append error message into log
  echo "$data user or password empty: FAIL" >> "log/session-create.log"
  # exit this script
  exit 0
else
  checkDirExists
  convertMD5
  checkExistsSESS_ID
fi
