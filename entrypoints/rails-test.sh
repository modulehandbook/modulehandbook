#!/bin/bash

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "----------  entrypoint = $0 --------"
echo "----------  RAILS_ENV = ${RAILS_ENV} --------"
echo "----------  MODHAND_IMAGE = ${MODHAND_IMAGE} --------"

bundle exec rails db:create
bundle exec rails db:schema:load
tail -f Gemfile
# bundle exec rails test
# bundle exec rails test:system


# tail -f Gemfile
