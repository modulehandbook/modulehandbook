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



echo "deploy $TAG to $ENV"

deploy/_deploy.sh $ENV $TAG 
