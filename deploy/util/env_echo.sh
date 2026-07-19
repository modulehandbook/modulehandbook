#!/bin/bash
export X=Y
#for l in $(cat .env); do 
while read line; do
    if [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*=.*$ ]]; then
        var_name=$(echo $line | sed -e "s/=.*//g")
        echo "$var_name=${!var_name}"
        #echo "$var_name=$(eval "echo $$var_name")"
        
    #else
        # echo "ignoring line: $line"

    fi
done < .env
