#!/bin/bash

ENV=$1
if [[ "" == $ENV ]]; then
    echo "pass environment (staging|production) as parameter."
    exit 1
fi

source ./secrets/env/$ENV.env
set -x

ssh $HOST "mkdir -p ~/secrets/nginx/$ENV"

scp  secrets/nginx/$NGINX_CERT $HOST:~/secrets/nginx/$NGINX_CERT
ssh $HOST "sudo chmod 644 ~/secrets/nginx/$NGINX_CERT"

ssh $HOST "sudo rm ~/secrets/nginx/$NGINX_KEY"
scp  secrets/nginx/$NGINX_KEY $HOST:~/secrets/nginx/$NGINX_KEY
ssh $HOST "sudo chmod 600 ~/secrets/nginx/$NGINX_KEY"
ssh $HOST "sudo chown root ~/secrets/nginx/$NGINX_KEY"
ssh $HOST "sudo chgrp root ~/secrets/nginx/$NGINX_KEY"