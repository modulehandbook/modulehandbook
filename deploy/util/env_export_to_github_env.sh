#!/bin/bash

environment=$1

if [ "$environment" == "" ]; then
    echo "environment missing!"
    exit 7
else
    env_file=deploy/environments/${environment}.env
fi


while read line; do
    if [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*=.*$ ]]; then

        echo "$line" >> $GITHUB_ENV
        
    #else
        # echo "ignoring line: $line"

    fi
done < ${env_file}
