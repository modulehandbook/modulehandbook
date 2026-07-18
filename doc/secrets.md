

# secrets in docker

- https://docs.docker.com/reference/build-checks/secrets-used-in-arg-or-env/

docker build . -t modsec --target modhand-prod --secret id=rails_master_key,env=RAILS_MASTER_KEY


docker build --secret id=rails_master_key,env=RAILS_MASTER_KEY --target modhand-prod .