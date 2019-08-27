#! /bin/bash
function restart {
    echo $1
    echo $2
    az vm restart -g $1 -n "$2"
}


RG="m-$1-Agents-$2-$3-rg"
LIST=$(az vm list -g $RG --query "[].name" -o tsv)

for OUTPUT in $LIST 
do
restart $RG $OUTPUT
done