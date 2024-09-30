#!/bin/bash
ENV=$1
TAG=$2

source ./deploy/environments/$ENV.env
echo "about to deploy commit $TAG to $ENV"

set -x
echo "-----------"
# scp secrets/env/$ENV.env $HOST:~/secrets/env/active.env
# ersetzen mit
scp Makefile.prod $HOST:~/Makefile
scp compose.yaml $HOST:~
scp -r nginx $HOST:~
scp -r deploy $HOST:~
ssh $HOST "ln -sf deploy/environments/$ENV.env active-environment.env"

# .env
scp .env $HOST:~
ssh $HOST "echo TAG_MODULE_HANDBOOK=$TAG >> .env"
echo RAILS_MASTER_KEY=$(cat secrets/config/credentials/$ENV.key) | ssh $HOST "cat >> .env"

ssh $HOST "sudo docker compose down"
ssh $HOST "sudo docker compose up -d"
