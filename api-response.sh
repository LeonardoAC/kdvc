#!/bin/sh
#
# LEONARDO A CARRILHO
# 2020, SEPTEMBER
# Send back to frontend the response in Json
# Only this file will return back to frontend. The anothers one won't have CORS in it.
#
#
# **************************************************************************
#	ATENCAO: O cross origin e o echo vazio abaixo
# nao podem ser retirados sobre pena de nao funcionar corretamente.
# CORS
# **************************************************************************
echo "Access-Control-Allow-Origin: *"
echo

#echo "api-response says: "$1
echo $1
# Please, have on mind you have to pass Json arguments.
