# use this to link a local exporter instance for development:
# export EXPORTER_BASE_URL=http://host.docker.internal:3030/
restart: stop start
clean_logs:
	rm container_logs/nginx/*.*
	rm container_logs/*.*
start_prod_mode:
	docker-compose -f docker-compose.yml up -d # ommits override
start_prod_version:
	docker-compose -f docker-compose.yml --env-file .env.prod up
start_prod_local:
	docker-compose -f docker-compose.yml -f docker-compose.localprod.yml up
start:
	docker-compose up -d
start_with_output:
	docker-compose up
startdb:
	docker-compose up -d module-handbook-postgres
exec:
	docker-compose exec module-handbook bash
bash:
	docker-compose exec module-handbook bash
bash_db:
	docker-compose exec module-handbook-postgres bash
bash_nginx:
	docker-compose exec nginx bash
rebuild:
	docker-compose up -d --build --force-recreate module-handbook
stop: down
down:
	docker-compose down
clean:
	rm -rf gem_cache
	docker-compose down --rmi all -v --remove-orphans
open:
	open http://localhost:3000

#
# DB Tasks via rails
#
init: new_db import_dump
new_db:
	docker-compose exec module-handbook rails db:create
	docker-compose exec module-handbook rails db:migrate
new_db_seed: new_db
	docker-compose exec module-handbook rails db:seed
recreate_db:
	docker-compose exec module-handbook rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=development
	docker-compose exec module-handbook rails db:create RAILS_ENV=development
	docker-compose exec module-handbook rails db:migrate RAILS_ENV=development
migrate:
	docker-compose exec -T module-handbook rails db:migrate
reset_db:
	docker-compose exec module-handbook rails db:drop  DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=development
	docker-compose exec module-handbook rails db:create RAILS_ENV=development
	docker-compose exec module-handbook rails db:migrate
	docker-compose exec module-handbook rails db:seed
#
# DB Backup Heroku
#
crondump:
	rm -f latest.dump
	/usr/local/bin/heroku pg:backups:capture
	/usr/local/bin/heroku pg:backups:download
	mv latest.dump ../dumps/uas-module-handbook-cron-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump

make_dump:
	docker-compose exec -T module-handbook-postgres pg_dump --create --verbose --clean --no-acl --no-owner -h localhost -U modhand  ${DBNAME}

#
# DB Import Tasks directly via postgres container
#
# DBNAME=modhand-db-dev
# DBNAME=modhand-db-prod file=
import_dump_complete: recreate_db import_dump
# import from local file using cat:
# call with  make file=x.pgdump import_dump
import_dump: $(file)
	cat $(file) | docker-compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d ${DBNAME}
# this produces errors on a newly created db as rails already creates indices etc.
# thus, this way is less preferable as errors are not shown:
# import from file **in container** (use mounted transfer dir, e.g. see docker_compose)
import_dump_via_transfer_dir:
		docker-compose exec modulehandbook-database pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d ${DBNAME} /var/lib/postgresql/$(file)

#
# Testing
#
# to be able to have a target named test, it needs to be declared phony as a file with this name exists.
.PHONY: test
test: test_app
test_all:
	docker-compose exec module-handbook rails test
	docker-compose exec module-handbook rails test:system
test_app:
	docker-compose exec module-handbook rails db:create RAILS_ENV=test
	docker-compose exec module-handbook rails db:migrate RAILS_ENV=test
	docker-compose exec module-handbook rails test
	docker-compose exec module-handbook rails test:system
reset_db_local:
	rails db:drop RAILS_ENV=development
	rails db:create RAILS_ENV=development
	rails db:migrate
	rails db:seed
rails_test:
	# common fixes on Lottes Laptop
	# in test_helper.rb -> parallelize(workers: 1)
	# export DISABLE_SPRING=true
	rails db:drop RAILS_ENV=test
	rails db:create RAILS_ENV=test
	rails db:migrate RAILS_ENV=test
	rails test
	rails test:system

#
# server admin
#
deploy_staging: cp_staging restart_staging

check_staging:
	ssh local@module-handbook-staging.f4.htw-berlin.de "docker ps; df -h"
restart_staging:
	ssh local@module-handbook-staging.f4.htw-berlin.de "docker-compose down"
	ssh local@module-handbook-staging.f4.htw-berlin.de "docker-compose up -d"
ssh_staging:
	ssh local@module-handbook-staging.f4.htw-berlin.de
cp_staging:
	scp Makefile.prod local@module-handbook-staging.f4.htw-berlin.de:~/Makefile
	scp docker-compose.yml local@module-handbook-staging.f4.htw-berlin.de:~
	scp .env.staging local@module-handbook-staging.f4.htw-berlin.de:~/.env
	scp -r nginx local@module-handbook-staging.f4.htw-berlin.de:~
	scp secrets/secrets.env local@module-handbook-staging.f4.htw-berlin.de:~/secrets


cp_entrypoint:
	scp entrypoints/docker-entrypoint.sh local@module-handbook-staging.f4.htw-berlin.de:~/entrypoints/docker-entrypoint.sh

ssh_prod:
	ssh local@module-handbook.f4.htw-berlin.de

cp_prod:
	scp Makefile.prod local@module-handbook.f4.htw-berlin.de:~/Makefile
	scp docker-compose.yml local@module-handbook.f4.htw-berlin.de:~
	scp .env.production local@module-handbook.f4.htw-berlin.de:~/.env
	scp -r nginx local@module-handbook.f4.htw-berlin.de:~
	ssh local@module-handbook.f4.htw-berlin.de "mkdir -p /home/local/secrets"
	ssh local@module-handbook.f4.htw-berlin.de "mkdir -p secrets/nginx/production"
	scp secrets/secrets.env local@module-handbook.f4.htw-berlin.de:~/secrets
check_production:
	ssh local@module-handbook.f4.htw-berlin.de "docker ps; df -h"

open_production:
		open https://module-handbook-staging.f4.htw-berlin.de

open_staging:
	open https://module-handbook-staging.f4.htw-berlin.de

start_production_local:
	 docker-compose -f docker-compose.yml --env-file .env.production up
start_staging_local:
	 docker-compose -f docker-compose.yml --env-file .env.staging up

start_local_build_staging:
	 	 docker-compose -f docker-compose.yml -f docker-compose.localprod.yml --env-file .env.staging up

start_local_build_prod:
	 	 docker-compose -f docker-compose.yml -f docker-compose.localprod.yml --env-file .env.production up


#  ** wip **

reset_prod_db:
	docker-compose exec module-handbook rails db:create RAILS_ENV=production
	docker-compose exec module-handbook rails db:migrate
import_dump_staging:
	cat $(file) | ssh local@module-handbook-staging.f4.htw-berlin.de "docker-compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand-db-prod"

import_dump_production:
	cat $(file) | ssh local@module-handbook.f4.htw-berlin.de "docker-compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand-db-prod"


cert:
	openssl genrsa -aes256 -passout pass:gsahdg -out server.pass.key 4096
	openssl rsa -passin pass:gsahdg -in server.pass.key -out server.key
	openssl req -new -key server.key -out server.csr
	openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt
