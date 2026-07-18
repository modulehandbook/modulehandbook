#!/bin/bash


#
# 
# This script is called by production.sh etc
#
#

ENV=$1
TAG=$2

source ./deploy/environments/$ENV.env
echo "---  deploy $TAG to $ENV ($HOST)"

if [ "$RAILS_MASTER_KEY" == "" ]; then
  echo "RAILS_MASTER_KEY not set, using config/credentials/$ENV.key"
  export RAILS_MASTER_KEY="$(cat config/credentials/$ENV.key)"
  echo set to: $RAILS_MASTER_KEY
fi

#export RAILS_MASTER_KEY=$(cat secrets/config/credentials/$ENV.key)
if [ $RAILS_MASTER_KEY = "" ]; then
  echo "RAILS_MASTER_KEY missing"
  exit 42
fi

set -x
echo "-----------"

scp compose.yaml $HOST:~

scp -r nginx $HOST:~
scp -r entrypoints $HOST:~


scp deploy/vms/copy_to_host_home_directories/* $HOST:~
scp deploy/vms/copy_to_host_home_directories/.bashrc $HOST:~


# .env
scp ./deploy/environments/$ENV.env $HOST:~/.env

ssh $HOST "echo TAG_MODULE_HANDBOOK_EXPORTER=sha-4ef1b2d >> .env"
ssh $HOST "echo RAILS_MASTER_KEY=$RAILS_MASTER_KEY >> .env"
ssh $HOST "echo TAG_MODULE_HANDBOOK=$TAG >> .env"


#echo RAILS_MASTER_KEY=$(cat secrets/config/credentials/$ENV.key) | ssh $HOST "cat >> .env"

ssh $HOST "docker compose down"
ssh $HOST "docker compose up -d"
