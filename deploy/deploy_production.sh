#!/bin/bash

ENV=production
TAG=$1

deploy/deploy.sh $ENV $TAG

