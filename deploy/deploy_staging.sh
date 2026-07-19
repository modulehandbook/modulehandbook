#!/bin/bash

ENV=staging


TAG=$1
if [ $TAG == ""]; then
    TAG=sha-$(git rev-parse --short origin/main)
fi

echo "deploy $TAG to staging"

deploy/_deploy.sh $ENV $TAG 
