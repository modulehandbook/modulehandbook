#!/bin/bash

#for l in $(cat .env); do 
while read line; do
    if [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*=.*$ ]]; then
        
        export $line; 
        
    #else
        # echo "ignoring line: $line"

    fi
done < .env
