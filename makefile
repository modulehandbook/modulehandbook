start:
	docker-compose up -d
starts:
	docker-compose up
startdb:
	docker-compose up -d postgresql
exec:
	docker-compose exec module-handbook bash
new_db:
	docker-compose exec module-handbook rails db:create
	docker-compose exec module-handbook rails db:migrate
	docker-compose exec module-handbook rails db:seed
bash:
	docker-compose exec module-handbook bash
bash_db:
	docker-compose exec module-handbook-postgres bash
import_dump: $(file)
	rails db:drop
	rails db:create
	cat $(file) | docker-compose exec -T postgresql psql --set ON_ERROR_STOP=on -h localhost -U modhand modhand -f -
	rails db:migrate
rebuild:
	docker-compose up -d --build --force-recreate module-handbook
down:
	docker-compose down
clean:
	rm -rf gem_cache
	docker-compose down --rmi all -v --remove-orphans
dump:
	/usr/local/bin/heroku pg:backups:capture
	/usr/local/bin/heroku pg:backups:download
	mv latest.dump ../dumps/uas-module-handbook-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump
crondump:
	rm -f latest.dump
	/usr/local/bin/heroku pg:backups:capture
	/usr/local/bin/heroku pg:backups:download
	mv latest.dump ../dumps/uas-module-handbook-cron-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump
db_restore: $(file)
	docker-compose exec postgresql pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand /var/lib/postgresql/$(file)
reset_db:
	rails db:drop RAILS_ENV=development
	rails db:create RAILS_ENV=development
	rails db:migrate
	rails db:seed
webpacker_stop:
	kill $(ps aux | grep 'webpack' | awk '{print $2}')
yarn_update_docx:
	yarn upgrade docx
	cp node_modules/docx/build/index.js public/docx/index.js
yarn_update:
	yarn upgrade
	cp node_modules/docx/build/index.js public/docx/index.js
test_all:
     docker-compose exec module-handbook rails test
     docker-compose exec module-handbook rails test:system
test_app:
 	docker-compose exec module-handbook rails db:create RAILS_ENV=test
 	docker-compose exec module-handbook rails db:migrate RAILS_ENV=test
 	docker-compose exec module-handbook rails test
    docker-compose exec module-handbook rails test:system
rails_test:
	# common fixes on Lottes Laptop
	# in test_helper.rb -> parallelize(workers: 1)
	# export DISABLE_SPRING=true
	rails db:drop RAILS_ENV=test
	rails db:create RAILS_ENV=test
	rails db:migrate RAILS_ENV=test
	rails test
	rails test:system
