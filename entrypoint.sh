#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

# if rails doesn't start, replace the start command with this one:
# tail -f /dev/null
# this keeps the container running without attempting to start rails.
