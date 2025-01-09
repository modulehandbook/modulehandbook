#!/bin/bash
ENV=$1
TAG=$2

RAILS_MASTER_KEY=$RAILS_MASTER_KEY

source ./deploy/environments/$ENV.env
echo "about to deploy commit $TAG to $ENV"

set -x
echo "-----------"

scp Makefile.prod $HOST:~/Makefile
scp compose.yaml $HOST:~
scp -r nginx $HOST:~
scp deploy/environments/$ENV.env $HOST:active-environment.env

# RAILS_MASTER_KEY=$(cat secrets/config/credentials/$ENV.key)
if [ $RAILS_MASTER_KEY = "" ]; then
  echo "RAILS_MASTER_KEY missing"
  exit 42
fi

# .env

ssh $HOST "echo TAG_MODULE_HANDBOOK_EXPORTER=sha-4ef1b2d > .env"
ssh $HOST "echo RAILS_MASTER_KEY=$RAILS_MASTER_KEY >> .env"
ssh $HOST "echo TAG_MODULE_HANDBOOK=$TAG >> .env"


#echo RAILS_MASTER_KEY=$(cat secrets/config/credentials/$ENV.key) | ssh $HOST "cat >> .env"

ssh $HOST "sudo docker compose down"
ssh $HOST "sudo docker compose up -d"
