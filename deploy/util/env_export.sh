#!/bin/bash

# exports environment from .env to make it available
# to rails started directly on host

environment=$1
echo ${environment}

if [[ "${environment}" == "" ]]; then
    env_file=.env
else
    env_file=deploy/environments/${environment}.env
fi


while read line; do
    if [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*=.*$ ]]; then
        
        export $line; 
        
    #else
        # echo "ignoring line: $line"

    fi
done < .env
