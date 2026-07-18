#!/bin/bash

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "----------  RAILS_ENV = ${RAILS_ENV} --------"
echo "----------  MODHAND_IMAGE = ${MODHAND_IMAGE} --------"

# 18.07.26: das war ein Versuch assets precompile aus dem 
# Dockerfile rauszunehmen und stattdessen beim Neustart 
# auszuführen. 
# der Container crasht aber bei rails assets:precompile.
# 
# if [ "$RAILS_ENV" == "development" ]; then
#   echo "environment is dev, skipping asset precompilation"
#   bundle exec rails css:build
# else
#   bundle exec rails assets:precompile
# fi

# bundle exec rails db:migrate
# bundle exec rails s -b 0.0.0.0

tail -f Gemfile
