#!/bin/bash

TAG=$1
ENV=$2

if [ "$TAG" == "" ]; then
    echo TAG missing 
    exit 11
fi

if [ "$ENV" == "" ]; then
    echo ENV missing 
    exit 12
fi

if [[ "$CI" == "" ]]; then
    echo "running locally, setting environment variables"
    . ./deploy/environments/${ENV}.env
    . ./secrets/more_env.sh

    . ./deploy/util/env_echo.sh

    export RAILS_MASTER_KEY=$(cat config/credentials/${ENV}.key)
    
fi


echo "deploy_environment: deploy $TAG to $ENV"

deploy/_deploy.sh $ENV $TAG 
