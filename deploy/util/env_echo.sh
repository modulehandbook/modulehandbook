#!/bin/bash
environment=$1
if [ "$environment" == "" ]; then
    env_file=".env"
else
    env_file=deploy/environments/${environment}.env
fi

while read line; do
    if [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*=.*$ ]]; then
        var_name=$(echo $line | sed -e "s/=.*//g")
        echo "$var_name=${!var_name}"
    fi
done < ${env_file}
