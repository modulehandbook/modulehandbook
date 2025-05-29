#!/bin/bash
ENV=$1
TAG=$2

RAILS_MASTER_KEY=$RAILS_MASTER_KEY

source ./deploy/environments/$ENV.env
echo "about to deploy commit $TAG to $ENV"

set -x
echo "-----------"

if [ "$ENV" = "staging" ]; then
  COMPOSE_FILE="compose.staging.yaml"
  NGINX_FOLDER="nginx_staging"

  ssh $HOST "mkdir -p ~/deploy/environments"
  scp deploy/environments/staging.env $HOST:deploy/environments/staging.env
  scp deploy/environments/giu_production.env $HOST:deploy/environments/giu_production.env
else
  COMPOSE_FILE="compose.yaml"
  NGINX_FOLDER="nginx"

  scp deploy/environments/$ENV.env $HOST:active-environment.env
fi

scp Makefile.prod $HOST:~/Makefile
scp $COMPOSE_FILE $HOST:~/compose.yaml
scp -r $NGINX_FOLDER $HOST:nginx

if [ "$ENV" != "staging" ]; then
  RAILS_MASTER_KEY=$(cat secrets/config/credentials/$ENV.key 2>/dev/null)
  if [ -z "$RAILS_MASTER_KEY" ]; then
    echo "RAILS_MASTER_KEY missing for $ENV"
    exit 42
  fi
fi

# .env

ssh $HOST "echo TAG_MODULE_HANDBOOK_EXPORTER=sha-4ef1b2d > .env"
ssh $HOST "echo TAG_MODULE_HANDBOOK=$TAG >> .env"

if [ "$ENV" = "staging" ]; then
  ssh $HOST "echo RAILS_MASTER_KEY_STAGING=$RAILS_MASTER_KEY_STAGING >> .env"
  ssh $HOST "echo RAILS_MASTER_KEY_PRODUCTION=$RAILS_MASTER_KEY_PRODUCTION >> .env"
else
  ssh $HOST "echo RAILS_MASTER_KEY=$RAILS_MASTER_KEY >> .env"
fi


#echo RAILS_MASTER_KEY=$(cat secrets/config/credentials/$ENV.key) | ssh $HOST "cat >> .env"

ssh $HOST "sudo docker compose down"
ssh $HOST "sudo docker compose up -d"
