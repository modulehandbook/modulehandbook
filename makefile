# use this to link a local exporter instance for development:
# export EXPORTER_BASE_URL=http://host.docker.internal:3030/
.RECIPEPREFIX = -
restart: stop start
clean_logs:
- rm container_logs/nginx/*.*
- rm container_logs/*.*
start_prod_mode:
- docker-compose -f docker-compose.yml up -d # ommits override
start_prod_version:
- docker-compose -f docker-compose.yml --env-file .env.prod up
start_prod_local:
- docker-compose -f docker-compose.yml -f docker-compose.localprod.yml up
start:
- docker-compose up -d
start_with_output:
- docker-compose up
startdb:
	docker-compose up -d module-handbook-mariadb
exec:
- docker-compose exec module-handbook bash
bash:
- docker-compose exec module-handbook bash
bash_db:
- docker-compose exec module-handbook-postgres bash
bash_nginx:
- docker-compose exec nginx bash
rebuild:
- docker-compose up -d --build --force-recreate module-handbook
stop: down
down:
- docker-compose down
clean:
- rm -rf gem_cache
- docker-compose down --rmi all -v --remove-orphans
open:
- open http://localhost:3000

#
# DB Tasks via rails
#
init: new_db import_dump
new_db:
- docker-compose exec module-handbook rails db:create
- docker-compose exec module-handbook rails db:migrate

seed:
- docker-compose exec module-handbook rails db:seed
recreate_db:
- docker-compose exec module-handbook rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=development
- docker-compose exec module-handbook rails db:create RAILS_ENV=development
- docker-compose exec module-handbook rails db:migrate RAILS_ENV=development
migrate:
- docker-compose exec -T module-handbook rails db:migrate
reset_db:
- docker-compose exec module-handbook rails db:drop  DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=development
- docker-compose exec module-handbook rails db:create RAILS_ENV=development
- docker-compose exec module-handbook rails db:migrate
- docker-compose exec module-handbook rails db:seed

#
# DB Import Tasks directly via postgres container
#
DBNAME=modhand-db-dev
# DBNAME=modhand-db-prod file=
import_dump_complete: recreate_db import_dump
# import from local file using cat:
# call with  make file=x.pgdump import_dump
import_dump_heroku: $(file)
- cat $(file) | docker-compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d ${DBNAME}
# e.g. DBNAME=modhand-db-dev  file=../dumps-htw/modhand-2022-12-18--21-00-02.pgdump make import_dump
import_dump: $(file)
- cat $(file) | docker-compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d ${DBNAME}
dump:
- docker-compose exec -T module-handbook-postgres pg_dump  -Fc --clean --if-exists --create --encoding UTF8 -h localhost -d ${DBNAME} -U modhand > ../mh-dumps/local/modhand-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump

# this produces errors on a newly created db as rails already creates indices etc.
# thus, this way is less preferable as errors are not shown:
# import from file **in container** (use mounted transfer dir, e.g. see docker_compose)
import_dump_via_transfer_dir:
- 	docker-compose exec modulehandbook-database pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d ${DBNAME} /var/lib/postgresql/$(file)
#
# Testing
#
# to be able to have a target named test, it needs to be declared phony as a file with this name exists.
.PHONY: test
test: test_app
test_all:
- docker-compose exec module-handbook rails test
- docker-compose exec module-handbook rails test:system
test_system:
- docker-compose exec module-handbook rails test:system
test_one:
- docker-compose exec module-handbook rails test test/system/comments/comments_editor_test.rb:55
test_app:
- docker-compose exec module-handbook rails db:create RAILS_ENV=test
- docker-compose exec module-handbook rails db:migrate RAILS_ENV=test
- docker-compose exec module-handbook rails test
- docker-compose exec module-handbook rails test:system

test_ci: test_ci_setup test_ci_just_the_tests
test_ci_setup:
- docker build -f Dockerfile --target modhand-base -t modhand-base:latest .
- docker build -f Dockerfile.testci --target modhand-testci -t modhand-testci:latest .
- docker-compose -f docker-compose.testci.yml --project-name module-handbook-citest up -d
- docker ps
- docker exec modulehandbook-testci rails db:drop RAILS_ENV=test
- docker exec modulehandbook-testci rails db:create RAILS_ENV=test
- docker exec modulehandbook-testci rails db:migrate RAILS_ENV=test
test_ci_just_the_tests:
- docker exec modulehandbook-testci rails test
- docker exec modulehandbook-testci rails test:system
- docker-compose -f docker-compose.testci.yml down

reset_db_local:
- rails db:drop RAILS_ENV=development
- rails db:create RAILS_ENV=development
- rails db:migrate
- rails db:seed

reset_test_db:
- docker restart modulehandbook-database
- RAILS_ENV=test rails db:drop
- RAILS_ENV=test rails db:create
- RAILS_ENV=test rails db:migrate
rails_test:
- # common fixes on Lottes Laptop
- # in test_helper.rb -> parallelize(workers: 1)
- # export DISABLE_SPRING=true
- rails db:drop RAILS_ENV=test
- rails db:create RAILS_ENV=test
- rails db:migrate RAILS_ENV=test
- rails test
- rails test:system

api_test:
- rails test test/../test-api/
#
# server admin
#
CLEAN = "docker rmi $(docker images -f reference='*ghcr.io/modulehandbook/modulehandbook*' -q)"
deploy_staging: cp_staging restart_staging
deploy_production: cp_production restart_production

check_staging:
- ssh local@module-handbook-staging.f4.htw-berlin.de "docker ps; df -h"
check_production:
- ssh local@module-handbook.f4.htw-berlin.de "docker ps; df -h"

restart_staging:
- ssh local@module-handbook-staging.f4.htw-berlin.de "sudo docker-compose down"
- ssh local@module-handbook-staging.f4.htw-berlin.de "sudo docker-compose up -d"
restart_production:
- ssh local@module-handbook.f4.htw-berlin.de "sudo docker-compose down"
- ssh local@module-handbook.f4.htw-berlin.de "sudo docker-compose up -d"

ssh_staging:
- ssh local@module-handbook-staging.f4.htw-berlin.de
ssh_production:
- ssh local@module-handbook.f4.htw-berlin.de

cp_staging:
- scp Makefile.prod local@module-handbook-staging.f4.htw-berlin.de:~/Makefile
- scp docker-compose.yml local@module-handbook-staging.f4.htw-berlin.de:~
- scp .env.staging local@module-handbook-staging.f4.htw-berlin.de:~/.env
- scp -r nginx local@module-handbook-staging.f4.htw-berlin.de:~
- scp secrets/secrets.env local@module-handbook-staging.f4.htw-berlin.de:~/secrets
cp_production:
- scp Makefile.prod local@module-handbook.f4.htw-berlin.de:~/Makefile
- scp docker-compose.yml local@module-handbook.f4.htw-berlin.de:~
- scp .env.production local@module-handbook.f4.htw-berlin.de:~/.env
- scp -r nginx local@module-handbook.f4.htw-berlin.de:~
- ssh local@module-handbook.f4.htw-berlin.de "mkdir -p /home/local/secrets"
- ssh local@module-handbook.f4.htw-berlin.de "mkdir -p secrets/nginx/production"
- scp secrets/secrets.env local@module-handbook.f4.htw-berlin.de:~/secrets

open_staging:
- open https://module-handbook-staging.f4.htw-berlin.de

open_production:
- open https://module-handbook.f4.htw-berlin.de

build_testci_images:
- docker build --target  modhand-prod-no-assets --tag modhand-prod-no-assets:latest .
- docker build --file Dockerfile.testci . --tag modhand-testci:latest
testci_local: build_testci_images testci
testci:
- docker-compose -f docker-compose.testci.yml up -d
- docker ps
- docker exec modulehandbook-testci rails db:drop RAILS_ENV=test
- docker exec modulehandbook-testci rails db:create RAILS_ENV=test
- docker exec modulehandbook-testci rails db:migrate RAILS_ENV=test
- docker exec modulehandbook-testci rails test
- docker exec modulehandbook-testci rails test:system


testci_stop:
- docker-compose -f docker-compose.testci.yml down

start_production_local:
-  docker-compose -f docker-compose.yml --env-file .env.production up
start_staging_local:
-  docker-compose -f docker-compose.yml --env-file .env.staging up

start_local_build_staging:
-  	 docker-compose -f docker-compose.yml -f docker-compose.localprod.yml --env-file .env.staging up

start_local_build_prod:
-  	 docker-compose -f docker-compose.yml -f docker-compose.localprod.yml --env-file .env.production up


#  ** wip **


reset_prod_db:
- docker-compose exec module-handbook rails db:create RAILS_ENV=production
- docker-compose exec module-handbook rails db:migrate
import_dump_staging:
- cat $(file) | ssh local@module-handbook-staging.f4.htw-berlin.de "docker-compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand-db-prod"

import_dump_production:
- cat $(file) | ssh local@module-handbook.f4.htw-berlin.de "docker-compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand-db-prod"

import_dump_local:
- cat $(file) | docker-compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d ${DBNAME}

dump_production:
- 	ssh local@module-handbook.f4.htw-berlin.de "docker-compose exec -T module-handbook-postgres pg_dump  -Fc --clean --if-exists --create --encoding UTF8 -h localhost -d modhand-db-prod -U modhand" > ../dumps-htw/modhand-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump
cron_dump:
- # ping -t 2 module-handbook.f4.htw-berlin.de; if [ $$? == 0 ]; then ssh local@module-handbook.f4.htw-berlin.de "docker-compose exec -T module-handbook-postgres pg_dump  -Fc --clean --if-exists --create --encoding UTF8 -h localhost -d modhand-db-prod -U modhand" > ../dumps-htw/modhand-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump ; fi
- PING := $(ping -t 2 module-handbook.f4.htw-berlin.de)
- echo pingable
- ssh local@module-handbook.f4.htw-berlin.de "docker-compose exec -T module-handbook-postgres pg_dump  -Fc --clean --if-exists --create --encoding UTF8 -h localhost -d modhand-db-prod -U modhand" > ../dumps-htw/modhand-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump


# docker images -f reference='*ghcr.io/modulehandbook/modulehandbook*'

cert:
- openssl genrsa -aes256 -passout pass:gsahdg -out server.pass.key 4096
- openssl rsa -passin pass:gsahdg -in server.pass.key -out server.key
- openssl req -new -key server.key -out server.csr
- openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt

# übernommen von der imimap


#DUMP_COMMAND_WDROP="pg_dump --create --clean --no-acl --no-owner -h localhost -U modhand modhand-db-prod"
#IMPORT_COMMAND="psql --set ON_ERROR_STOP=on -h localhost -U modhand modhand-db-prod -f -"
#DUMP_COMMAND="docker exec modulehandbook-database pg_dump -h localhost -U modhand modhand-db-prod"
#
#
#prod_dump:
#	mkdir -p ../htw-dumps
#	ssh local@module-handbook.f4.htw-berlin.de "docker exec postgres pg_dump -h localhost -U modhand modhand-db-prod" > ../htw-dumps/modhand-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump
#import: $(file)
#	cat $(file) | docker-compose exec -T module-handbook-postgres psql --set ON_ERROR_STOP=on -h localhost -U modhand modhand-db-prod -f -



#------------
list_db:
- psql -h localhost -l -U modhand

# pip3 install pyyaml
# call with make yaml yf=
yaml:
- python3 -c 'import yaml, sys; print(yaml.safe_load(sys.stdin))' < $(yf)

find_duplicates:
- echo "OneNameTest ist die Demo, der name darf doppelt da sein"
- find . -name "*.rb" | xargs grep "^\s*class" | sed -e "s/.*class//g" | sed -e "s/ <.*//g" |  sort | uniq -c| grep -v -e "1"

rails_c_db_container:
- POSTGRES_DB=modhand-db-dev  RAILS_ENV=development rails c
