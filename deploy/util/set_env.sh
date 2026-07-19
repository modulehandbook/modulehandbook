ENV=$1

. ./secrets/more_env.sh

./deploy/util/env_export.sh ${ENV}

cat config/credentials/${ENV}.key
export RAILS_MASTER_KEY=$(cat config/credentials/${ENV}.key)

