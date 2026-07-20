#!/bin/bash

export RAILS_MASTER_KEY="$(cat config/credentials/development.key)"
cp deploy/environments/development.env .env
echo TAG_MODULE_HANDBOOK_EXPORTER=sha-4ef1b2d >> .env
echo RAILS_MASTER_KEY=$RAILS_MASTER_KEY >> .env
echo TAG_MODULE_HANDBOOK=latest >> .env