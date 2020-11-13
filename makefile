start:
	docker-compose up -d
starts:
	docker-compose up
startdb:
	docker-compose -f docker-compose-pg12.yml up -d  postgresql
startdb_11:
	docker-compose -f docker-compose-pg11.yml up postgresql
import_dump: $(file)
	rails db:drop
	rails db:create
	cat $(file) | docker-compose exec -T postgresql psql --set ON_ERROR_STOP=on -h localhost -U modhand modhand -f -
	rails db:migrate
import_dump_11: $(file)
	rails db:drop
	ails db:create
	cat $(file) | docker-compose exec -T postgresql-11 psql -h localhost -U modhand modhand -f -
	rails db:migrate
docker_clean:
	docker-compose down
	docker rm $(docker ps -qa)
	docker rmi $(docker images -qa)
restore_dump: $(file_source) $(file_target)
	pg_restore -f $(file_target) $(file_source) # dump-2020-05-04.dump mh-dump-2020-05-04.dump
dump:
	heroku pg:backups:capture
	heroku pg:backups:download
	mv latest.dump ../dumps/uas-module-handbook-$(shell date +%Y-%m-%d).pgdump
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
	rails db:create RAILS_ENV=test
	rails db:migrate RAILS_ENV=test
	rails test
