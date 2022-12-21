#!/bin/bash

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "----------  RAILS_ENV = ${RAILS_ENV} --------"
echo "----------  MODHAND_IMAGE = ${MODHAND_IMAGE} --------"

bundle exec rails db:migrate
bundle exec rake db:create_faculties
bundle exec rails s -b 0.0.0.0

#tail -f Gemfile
