#!/bin/bash

for h in $(cat deploy/util/hosts)
do
    echo 
    echo "-----------   $h   -----------"
    echo
    ssh local@$h "sudo ./firewall-mit-mh-imports.sh"
done
