#!/bin/bash


#
# 
# This script is called by production.sh etc
#
#

ENV=$1
TAG=$2

if [[ "$ENV" == "" || "$TAG" == "" ]; then
  echo usage: _deploy <ENV> <TAG> 
  exit 1
fi

if [[ "$USER" == "" ]; then
  echo $USER environment variable needs to be set 
  exit 2
fi


source ./deploy/environments/$ENV.env
echo "---  deploy $TAG to $ENV ($HOST)"

UHOST="$USER@$HOST"


if [ "$RAILS_MASTER_KEY" == "" ]; then
  echo "RAILS_MASTER_KEY not set, using config/credentials/$ENV.key"
  export RAILS_MASTER_KEY="$(cat config/credentials/$RAILS_ENV.key)"
  echo set to: $RAILS_MASTER_KEY
fi

#export RAILS_MASTER_KEY=$(cat secrets/config/credentials/$ENV.key)
if [ $RAILS_MASTER_KEY == "" ]; then
  echo "RAILS_MASTER_KEY missing"
  exit 42
fi

set -x
echo "-----------"

scp compose.yaml $UHOST:~

scp -r nginx $UHOST:~
scp -r entrypoints $UHOST:~


scp deploy/vms/copy_to_host_home_directories/* $UHOST:~
scp deploy/vms/copy_to_host_home_directories/.bashrc $UHOST:~


# .env
scp ./deploy/environments/$ENV.env $UHOST:~/.env

ssh $UHOST "echo TAG_MODULE_HANDBOOK_EXPORTER=sha-4ef1b2d >> .env"
ssh $UHOST "echo RAILS_MASTER_KEY=$RAILS_MASTER_KEY >> .env"
ssh $UHOST "echo TAG_MODULE_HANDBOOK=$TAG >> .env"



ssh $UHOST "docker compose down"
ssh $UHOST "docker compose up -d"
