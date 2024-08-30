#!/bin/bash

ENV=staging
#TAG=sha-$(git rev-parse --short origin/main)
TAG=sha-$(git rev-parse --short origin/prepare_ssh_deployment)

deploy/deploy.sh $ENV $TAG


