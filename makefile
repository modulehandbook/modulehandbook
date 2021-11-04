start:
	docker-compose up -d
starts:
	docker-compose up
startdb:
	docker-compose -f docker-compose-pg12.yml up -d  postgresql
bash_db:
	docker-compose exec postgresql
import_dump: $(file)
	rails db:drop
	rails db:create
	cat $(file) | docker-compose exec -T postgresql psql --set ON_ERROR_STOP=on -h localhost -U modhand modhand -f -
	rails db:migrate
docker_clean:
	docker-compose down
	docker rm $(docker ps -qa)
	docker rmi $(docker images -qa)
dump:
	/usr/local/bin/heroku pg:backups:capture
	/usr/local/bin/heroku pg:backups:download
	mv latest.dump ../dumps/uas-module-handbook-$(shell date +%Y-%m-%d--%H-%M-%S).pgdump
bash:
	docker-compose exec module-handbook-rails bash
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
rails_test:
	# common fixes on Lottes Laptop
	# in test_helper.rb -> parallelize(workers: 1)
	# export DISABLE_SPRING=true
	rails db:drop RAILS_ENV=test
	rails db:create RAILS_ENV=test
	rails db:migrate RAILS_ENV=test
	rails test
	rails test:system
