.RECIPEPREFIX = -
.PHONY: test
# default sshid - overwrite with parameter if needed (eg.cronjob)
sshid=

# use this to link a local exporter instance for development:
# export EXPORTER_BASE_URL=http://host.docker.internal:3030/

# cleanup of target naming
# the make targets can target (;-/) either the host machine (e.g. your MacOS Laptop)
# or instances running in docker.

# for local development, you can use the following stacks:

# rails on host - db in container
# rails in container - db in container

# additionally, you may want to replicate production or staging 
# environments for specific testing.
# the main reason for this would usually be testing the 
# docker production image, thus running it locally.

# note that there is no current configuration for a local dev database, 
# thus all db-releated targets are only available for the container!

# nginx and exporter are currently disabled in compose.override.yaml


# here are some defaults
start: start_host
test: test_host
stop: stop_container
start_db: start_db_container

#
#    ---- HOST ----
#
#

# start rails locally - default target 
# Runs Rails on local Machine (with postgres in docker container)

start_host: start_db_container
- source .env && bin/rails s

open_in_browser:
- open http://localhost:3000

### Run this once after cloning the repo
init: start_db_container
- bin/bundle install
- yarn build:css
- bin/rails db:create
- bin/rails db:migrate
- bin/rails db:seed


test: start_db_container test_host static_code_checks

start_db_container:
- docker compose up -d module-handbook-postgres

test_all_host: test_host static_code_checks_host

test_host:
- PARALLEL_WORKERS=1 bin/rails test
- bin/rails test:system

static_code_checks_host:
- rubocop
- reek
- brakeman --no-pager


quick_push:
- git commit -am "quickpush $(shell date +%H-%M-%S) workflow wip" && git push && open https://github.com/modulehandbook/modulehandbook/actions
x_quick_push_old:
- git commit -am "commit at $(shell date "+%H:%M:%S")" && git push && open https://github.com/modulehandbook/modulehandbook/actions

#
#
#    ---- DOCKER ----
#
#

### Running Rails in Docker 

start_container:
- docker compose up -d

stop_container: 
- docker compose down

restart_container: stop_container start_container

rebuild_container:
- docker compose up -d --build --force-recreate module-handbook

rebuild2_container:
- docker compose build module-handbook
- docker compose up --no-deps -d module-handbook

#
#
#    ---- CLEANUP ----
#
#

clean_logs_host: 
- rm logs/nginx/*.*
- rm logs/*.*

clean_logs_container: bin
- rm container_logs/*.*

clean_docker:
- ./docker-cleanup.sh

#
#
#    ---- DATABASE MANAGEMENT ----
#
#

db_drop_test:
- RAILS_ENV=test bin/rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 
db_create_test:
- RAILS_ENV=test bin/rails db:create
db_start: start_db_container

db_create_test_container:
- docker compose exec module-handbook RAILS_ENV=test bin/rails db:create 
db_migrate_test_container:
- docker compose exec module-handbook RAILS_ENV=test bin/rails db:migrate 


### Running Tests in Docker
#
#
#    ---- TESTS in Docker ----
#
#

test_all_container: db_create_test_container db_migrate_test_container test_container 

test_container:
- docker compose exec module-handbook PARALLEL_WORKERS=1 bin/rails test 
- docker compose exec module-handbook PARALLEL_WORKERS=1 bin/rails test:system 



# use and change this to run single tests in docker
test_one_container:
- docker compose exec module-handbook rails test test/system/comments/comments_editor_test.rb:55
#
#
#    ---- VARIOUS DEBUG ----
#
#

### Run Rails with Production Configuration
# (will need appropriate RAILS_MASTER_KEY and TAG_MODULE_HANDBOOK set in environment!)

start_container_PROD:
- export RAILS_MASTER_KEY=$(cat secrets/config/credentials/production.key) && docker compose -f compose.yaml up -d # ommits override

start_container_DEBUG:
- docker compose -f compose.yaml -f compose.override.yaml  -f compose.debug.yaml  up

start_container_PROD_DEBUG:
- export RAILS_MASTER_KEY=$(cat secrets/config/credentials/production.key) && docker compose -f compose.yaml -f compose.debug.yaml up module-handbook

### Access Docker Container

bash:
- docker compose exec -ti module-handbook bash
bash_db:
- docker compose exec -ti module-handbook-postgres bash
bash_nginx:
- docker compose exec -ti nginx bash
bash_selenium:
- docker compose exec -ti selenium-standalone bash

#
#
#
#
#    ---- DB MAINTENANCE ----
#
#
#
#


dump_file=dumps/mh-imi-2026-07-18--22-00-00.pgdump
DBNAME=modhand-db-dev

import_dump_host: $(dump_file)
- cat $(dump_file) | docker compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d ${DBNAME}
- @echo "-----\nimported ${dump_file} to local host db"

##
# everything below is in need of cleanup! ---:
##
#file=$(shell cat tmp/DUMPFILENAME)
db_reset_local_docker:
- docker compose exec module-handbook rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=development
- docker compose exec module-handbook rails db:create RAILS_ENV=development
- docker compose exec module-handbook rails db:migrate RAILS_ENV=development
db_reset_local:
- rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=development
- rails db:create RAILS_ENV=development
- rails db:migrate RAILS_ENV=development
db_init_local: db_reset
- docker compose exec module-handbook rails db:seed

db_staging_to_dev: dump_staging import_dump


#
# DB Import Tasks directly via postgres container
#
DBNAME=modhand-db-dev
# DBNAME=modhand-db-prod file=
import_dump_complete: recreate_db import_dump
# import from local file using cat:
# call with  make file=x.pgdump import_dump

# e.g. DBNAME=modhand-db-dev  file=../dumps-htw/modhand-2022-12-18--21-00-02.pgdump make import_dump



local_dump_file=../mh-dumps/local/modhand-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump
dump_local:
- echo "dumping to ${local_dump_file}"
- docker compose exec -T module-handbook-postgres pg_dump  -Fc --clean --if-exists --create --encoding UTF8 -h localhost -d ${DBNAME} -U modhand > ${local_dump_file}
- echo ${local_dump_file} > tmp/DUMPFILENAME

# this produces errors on a newly created db as rails already creates indices etc.
# thus, this way is less preferable as errors are not shown:
# import from file **in container** (use mounted transfer dir, e.g. see docker_compose)
import_dump_via_transfer_dir:
- 	docker compose exec modulehandbook-database pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d ${DBNAME} /var/lib/postgresql/$(file)


#
#
#    ---- SERVER ADMIN ----
#
#

CLEAN = "docker rmi $(docker images -f reference='*ghcr.io/modulehandbook/modulehandbook*' -q)"

deploy_staging:
- ./deploy/staging.sh

#deploy_production:
#- ./deploy/production.sh

check_staging:
- ssh local@module-handbook-staging.f4.htw-berlin.de "docker ps; df -h"
check_production:
- ssh local@module-handbook.f4.htw-berlin.de "docker ps; df -h"
check_imi:
- ssh local@mh-imi.f4.htw-berlin.de "docker ps; df -h"

restart_staging:
- ssh local@module-handbook-staging.f4.htw-berlin.de "sudo docker compose down"
- ssh local@module-handbook-staging.f4.htw-berlin.de "sudo docker compose up -d"
restart_production:
- ssh local@module-handbook.f4.htw-berlin.de "sudo docker compose down"
- ssh local@module-handbook.f4.htw-berlin.de "sudo docker compose up -d"
restart_imi:
- ssh local@mh-imi.f4.htw-berlin.de "sudo docker compose down"
- ssh local@mh-imi.f4.htw-berlin.de "sudo docker compose up -d"

ssh_staging:
- ssh local@module-handbook-staging.f4.htw-berlin.de
ssh_production:
- ssh local@module-handbook.f4.htw-berlin.de
ssh_imi:
- ssh local@mh-imi.f4.htw-berlin.de

open_staging:
- open https://module-handbook-staging.f4.htw-berlin.de

open_production:
- open https://module-handbook.f4.htw-berlin.de



# ssh local@mh-imi.f4.htw-berlin.de "docker compose exec -ti module-handbook rails c"

#  ** wip **

import_dump_staging:
- echo "disabled"
- # cat $(file) | ssh local@module-handbook-staging.f4.htw-berlin.de "docker compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand-db-prod"

import_dump_production:
- echo "disabled - uncomment line below to temporarily enable it"
- echo using file $(file)
- # cat $(file) | ssh local@module-handbook.f4.htw-berlin.de "docker compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand-db-prod"

import_dump_local:
- cat $(file) | docker compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d ${DBNAME}

# this deletes the db and imports a dump from a sql file
import_dump_sql_local:
- rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=development
- cat $(file) | docker compose exec -T module-handbook-postgres psql  -h localhost -U modhand -d modhand-db-dev

import_dump_imi:
- echo "disabled - uncomment line below to temporarily enable it"
- echo using file $(file)
- cat $(file) | ssh local@mh-imi.f4.htw-berlin.de "docker compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand-db-prod"


staging_file=../modhand-dumps/modhand-stag-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump
dump_staging:
-   echo $(sshid)
-   echo ${staging_file} >> tmp/DUMPFILENAME
- 	ssh local@module-handbook-staging.f4.htw-berlin.de $(sshid)  "docker compose exec -T module-handbook-postgres pg_dump  -Fc --clean --if-exists --create --encoding UTF8 -h localhost -d modhand-db-prod -U modhand" > ${staging_file}

dump_production:
-   echo $(sshid)
- 	ssh local@module-handbook.f4.htw-berlin.de $(sshid)  "docker compose exec -T module-handbook-postgres pg_dump  -Fc --clean --if-exists --create --encoding UTF8 -h localhost -d modhand-db-prod -U modhand" > ../modhand-dumps/modhand-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump

dump_imi:
-   echo $(sshid)
- 	ssh local@mh-imi.f4.htw-berlin.de $(sshid) "docker compose exec -T module-handbook-postgres pg_dump  -Fc --clean --if-exists --create --encoding UTF8 -h localhost -d modhand-db-prod -U modhand" > ../modhand-dumps-imi/modhand-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump

cron_dump:
- # ping -t 2 module-handbook.f4.htw-berlin.de; if [ $$? == 0 ]; then ssh local@module-handbook.f4.htw-berlin.de "docker compose exec -T module-handbook-postgres pg_dump  -Fc --clean --if-exists --create --encoding UTF8 -h localhost -d modhand-db-prod -U modhand" > ../dumps-htw/modhand-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump ; fi
- PING := $(ping -t 2 module-handbook.f4.htw-berlin.de)
- echo pingable
- ssh local@module-handbook.f4.htw-berlin.de "docker compose exec -T module-handbook-postgres pg_dump  -Fc --clean --if-exists --create --encoding UTF8 -h localhost -d modhand-db-prod -U modhand" > ../dumps-htw/modhand-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump


# docker images -f reference='*ghcr.io/modulehandbook/modulehandbook*'

cert:
- openssl genrsa -aes256 -passout pass:gsahdg -out server.pass.key 4096
- openssl rsa -passin pass:gsahdg -in server.pass.key -out server.key
- openssl req -new -key server.key -out server.csr
- openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt


#------------
# unsorted  as of Saturday, 31.August 2024 17:05

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







## Tags
# delete remote tag: git push --delete origin refs/tags/abgabe


tags_origin:
- git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' origin



## Miscellaneous Stuff

list_targets:
- grep "^\w*:"  Makefile | sort


### Clean Gemcache, docker
clean:
- rm -rf gem_cache
- docker compose down --rmi all -v --remove-orphans


selenium:
- open http://localhost:7900/?autoconnect=1&resize=scale&password=secret

gemdir:
- pushd $(rvm gemdir)/gems

# -----

build:
- docker build . -f Dockerfile.alpine -t mh-rails80

build_production:
- RAILS_MASTER_KEY=$(shell cat config/credentials/production.key) && docker build -t modhand-prod --target modhand-prod --secret id=rails_master_key,env=RAILS_MASTER_KEY .

RAILS_MASTER_KEY=$(shell cat config/credentials/production.key)
DOCKER_ENV=-p 3004:3000 -e RAILS_MASTER_KEY='$(RAILS_MASTER_KEY)' -e POSTGRES_DB='mhdocker' -e RAILS_DB_HOST='host.docker.internal'

run:  opendocker
- docker rm -f mh-rails80
- docker run $(DOCKER_ENV) --name mh-rails80 mh-rails80 bin/rails server

opendocker: 
- open http://localhost:3004/


debug:
- docker build . -f Dockerfile.alpine --target debug -t rails80-alpine-debug
- docker run $(DOCKER_ENV) -it --name rails80-alpine-debug rails80-alpine-debug /bin/ash
#- docker run -e RAILS_MASTER_KEY='$(cat config/credentials/production.key)' -e POSTGRES_DB='modhand-db-prod' -e RAILS_DB_HOST='host.docker.internal' -it rails80-alpine-debug /bin/ash

shell-debug:
- docker exec -it  rails80-alpine-debug /bin/ash

shell:
- docker run -e RAILS_MASTER_KEY='$(cat config/credentials/production.key)' mh-rails80 /bin/ash

shell-in-running-container:
- docker exec -it mh-rails80 ash


compose: 
- export RAILS_MASTER_KEY=$(cat config/credentials/production.key); docker compose  -f compose.yaml up


#
#
# 
# 

# deprecated: use selenium standalone for test

start-test-environment:
- docker compose -f compose.yaml -f compose.override.yaml -f compose.test.yaml  up -d --remove-orphans
stop-test-environment:
- docker compose -f compose.yaml -f compose.override.yaml -f compose.test.yaml down

restart-selenium: stop-selenium start-selenium
start-selenium:
- docker compose -f compose.yaml -f compose.override.yaml -f compose.test.yaml  up -d selenium-standalone
stop-selenium:
- docker compose -f compose.yaml -f compose.override.yaml -f compose.test.yaml down selenium-standalone


show_credentials:
- ./deploy/show_credentials.sh

