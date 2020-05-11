startdb:
	docker-compose up postgresql -d
startdb_11:
	docker-compose up postgresql-11
import_dump: $(file)
	rails db:drop
	ails db:create
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
