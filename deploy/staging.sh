#!/bin/bash

ENV=staging
TAG=sha-$(git rev-parse --short origin/main)

deploy/deploy.sh $ENV $TAG


