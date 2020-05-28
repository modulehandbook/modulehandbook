startdb:
	docker-compose up -d
pgrestore: $(file)
	pg_restore -f $(file) decompressed$(file)
import: $(file)
		rails db:drop ; rails db:create
		cat $(file) | postgresql psql --set ON_ERROR_STOP=on -h localhost -U modhand modhand -f -
		rails db:migrate
