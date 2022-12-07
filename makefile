# use this to link a local exporter instance for development:
# export EXPORTER_BASE_URL=http://host.docker.internal:3030/
restart: stop start
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

#
# DB Import Tasks directly via postgres container
#
DBNAME=modhand-dev
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
ssh_staging:
	ssh local@module-handbook-staging.f4.htw-berlin.de
cp_staging:
	scp Makefile.prod local@module-handbook-staging.f4.htw-berlin.de:~/Makefile
	scp docker-compose.yml local@module-handbook-staging.f4.htw-berlin.de:~
	scp secrets.env local@module-handbook-staging.f4.htw-berlin.de:~
	scp .env.prod local@module-handbook-staging.f4.htw-berlin.de:~/.env
cp_entrypoint:
	scp entrypoints/docker-entrypoint.sh local@module-handbook-staging.f4.htw-berlin.de:~/entrypoints/docker-entrypoint.sh
ssh_prod:
	ssh local@module-handbook-staging.f4.htw-berlin.de
cp_prod:
	scp docker-compose.yml local@module-handbook.f4.htw-berlin.de:~
