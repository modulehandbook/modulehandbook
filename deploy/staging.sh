#!/bin/bash

ENV=staging
TAG=sha-$(git rev-parse --short origin/main)

echo "deploy $TAG to staging"

deploy/deploy.sh $ENV $TAG


