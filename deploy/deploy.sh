#!/bin/bash
ENV=$1
TAG=$2

source ./secrets/env/$ENV.env
echo "about to deploy commit $TAG to $ENV"

set -x
echo "-----------"
ssh $HOST "mkdir -p ~/secrets/env"
scp secrets/env/$ENV.env $HOST:~/secrets/env/active.env
# ersetzen mit
# ssh $HOST "ln -s deploy/environments/$ENV.env active-environment.sh"
secrets/env/$ENV.env $HOST:~/secrets/env/active.env
scp Makefile.prod $HOST:~/Makefile
scp compose.yaml $HOST:~
scp -r nginx $HOST:~

scp .env $HOST:~
ssh $HOST "echo TAG_MODULE_HANDBOOK=$TAG >> .env"

ssh $HOST "sudo docker compose down"
ssh $HOST "sudo docker compose up -d"
