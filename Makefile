.RECIPEPREFIX = -
.PHONY: test
# default sshid - overwrite with parameter if needed (eg.cronjob)
sshid=

# use this to link a local exporter instance for development:
# export EXPORTER_BASE_URL=http://host.docker.internal:3030/

# cleanup:

# environments:
# local
# docker
# test
# staging
# production

# tasks:

# build / initialization
# start
# stop
# test

#
#
#    ---- LOCAL ----
#
#

# start rails locally - default target 
# Runs Rails on local Machine (with postgres in docker container)
start_local: start_db open 
- bin/rails s

### Run this once after cloning the repo
init-local: start_db
- bin/bundle install
- bin/rails db:create
- bin/rails db:migrate
- bin/rails db:seed

test: start_db test_local static_code_checks

start_db:
- docker compose up -d module-handbook-postgres

open:
- open http://localhost:3000

test_local:
- bin/rails test
- bin/rails test:system

static_code_checks:
- rubocop
- reek
- brakeman


#
#
#    ---- DOCKER ----
#
#

### Running Rails in Docker 

start-docker:
- docker compose up -d

stop-docker: 
- docker compose down

start-test-environment:
- docker compose -f compose.yaml -f compose.override.yaml -f compose.test.yaml  up -d --remove-orphans
stop-test-environment:
- docker compose -f compose.yaml -f compose.override.yaml -f compose.test.yaml down

restart-selenium: stop-selenium start-selenium
start-selenium:
- docker compose -f compose.yaml -f compose.override.yaml -f compose.test.yaml  up -d selenium-standalone
stop-selenium:
- docker compose -f compose.yaml -f compose.override.yaml -f compose.test.yaml down selenium-standalone


db_drop_test:
- RAILS_ENV=test bin/rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 
db_create_test:
- RAILS_ENV=test bin/rails db:create
db_start: start-db


restart-docker: stop start

rebuild-docker:
- docker compose up -d --build --force-recreate module-handbook

rebuild2-docker:
- docker compose build module-handbook
- docker compose up --no-deps -d module-handbook


clean-logs-docker: bin
- rm container_logs/nginx/*.*
- rm container_logs/*.*

### Running Tests in Docker
#
#
#    ---- TESTS in Docker ----
#
#

test-docker: test-create-db test-migrate-db test-docker test-docker-system

test-docker-unit:
- docker compose exec module-handbook bin/rails test

test-docker-system:
- docker compose exec module-handbook rails test:system

test-create-db:
- docker compose exec module-handbook rails db:create RAILS_ENV=test
test-migrate-db:
- docker compose exec module-handbook rails db:migrate RAILS_ENV=test

# use and change this to run single tests in docker
test-one:
- docker compose exec module-handbook rails test test/system/comments/comments_editor_test.rb:55
#
#
#    ---- VARIOUS DEBUG ----
#
#

### Run Rails with Production Configuration
# (will need appropriate RAILS_MASTER_KEY and TAG_MODULE_HANDBOOK set in environment!)
start-docker-prod:
- docker compose -f compose.yaml up -d # ommits override

start-docker-debug:
- docker compose -f compose.yaml -f compose.override.yaml  -f compose.debug.yaml  up

debug-mh:
- TAG_MODULE_HANDBOOK=sha-2f14dca docker compose -f compose.yaml -f compose.debug.yaml up module-handbook

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


db_reset_local:
- docker compose exec module-handbook rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=development
- docker compose exec module-handbook rails db:create RAILS_ENV=development
- docker compose exec module-handbook rails db:migrate RAILS_ENV=development

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

file=$(shell cat tmp/DUMPFILENAME)
import_dump: $(file)
- cat $(file) | docker compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d ${DBNAME}
- echo "" > tmp/DUMPFILENAME

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

deploy_production:
- ./deploy/production.sh

check_staging:
- ssh local@module-handbook-staging.f4.htw-berlin.de "docker ps; df -h"
check_production:
- ssh local@module-handbook.f4.htw-berlin.de "docker ps; df -h"

restart_staging:
- ssh local@module-handbook-staging.f4.htw-berlin.de "sudo docker compose down"
- ssh local@module-handbook-staging.f4.htw-berlin.de "sudo docker compose up -d"
restart_production:
- ssh local@module-handbook.f4.htw-berlin.de "sudo docker compose down"
- ssh local@module-handbook.f4.htw-berlin.de "sudo docker compose up -d"

ssh_staging:
- ssh local@module-handbook-staging.f4.htw-berlin.de
ssh_production:
- ssh local@module-handbook.f4.htw-berlin.de

open_staging:
- open https://module-handbook-staging.f4.htw-berlin.de

open_production:
- open https://module-handbook.f4.htw-berlin.de

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





# https://depot.dev/blog/docker-clear-cache
docker-df:
- docker system df
docker-cleanup:
- docker image prune -a -f
- docker buildx prune -f

docker-rm:
- docker rm $(docker ps -qa)
- docker rmi $(docker images -qa)




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

quick-push:
- git commit -am "commit at $(shell date "+%H:%M:%S")" && git push && open https://github.com/modulehandbook/modulehandbook/actions

selenium:
- open http://localhost:7900/?autoconnect=1&resize=scale&password=secret

gemdir:
- pushd $(rvm gemdir)/gems
