#!/bin/bash

ENV=staging
#TAG=sha-$(git rev-parse --short origin/main)
TAG=sha-$(git rev-parse --short origin/new_deployment_scrapbook)

deploy/deploy.sh $ENV $TAG


