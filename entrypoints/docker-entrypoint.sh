#!/bin/bash

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

if [ $RAILS_MASTER_KEY == "REMOVE" ]; then
  echo "--------  RAILS_MASTER_KEY=${RAILS_MASTER_KEY} removed --------"
  unset RAILS_MASTER_KEY
fi

echo "----------  RAILS_ENV = ${RAILS_ENV} --------"


bundle exec rails s -b 0.0.0.0

#command: "tail -f Gemfile
