#!/bin/bash

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "----------  RAILS_ENV = ${RAILS_ENV} --------"
echo "----------  MODHAND_IMAGE = ${MODHAND_IMAGE} --------"

if [ "$RAILS_ENV" == "development" ]; then
  echo "environment is dev, skipping asset precompilation"
  bundle exec rails css:build
else
  bundle exec rails assets:precompile
fi

bundle exec rails db:migrate
bundle exec rails s -b 0.0.0.0

# tail -f Gemfile
