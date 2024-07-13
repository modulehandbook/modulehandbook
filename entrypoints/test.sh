#!/bin/bash

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "----------  RAILS_ENV = ${RAILS_ENV} --------"
echo "----------  MODHAND_IMAGE = ${MODHAND_IMAGE} --------"

bin/rails db:create
bin/rails db:migrate
# bin/rails rake db:create_faculties
bin/rails test
