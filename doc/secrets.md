
# secrets in docker

production build needs RAILS_MASTER_KEY
which is passed via --secret to the build.

- https://docs.docker.com/reference/build-checks/secrets-used-in-arg-or-env/


docker build --secret id=rails_master_key,env=RAILS_MASTER_KEY --target modhand-prod .