#!/bin/bash

ENV=staging
source secrets/more.env
./deploy/util/env_export.sh ${ENV}

TAG=$1
if [ $TAG == ""]; then
    TAG=sha-$(git rev-parse --short origin/main)
fi

echo "deploy $TAG to staging"

deploy/_deploy.sh $ENV $TAG 
