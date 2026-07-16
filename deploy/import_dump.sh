#!/bin/bash

DUMP_FILE=/Users/kleinen/mine/current/crontab/dumps/mh-imi/mh-imi-2026-07-16--12-00-00.pgdump
HOST=local@module-handbook-staging.f4.htw-berlin.de

DF=dump-for-import.pgdump

#scp $DUMP_FILE $HOST:$DF

cat ${DUMP_FILE} | ssh local@module-handbook-staging.f4.htw-berlin.de "docker compose exec -T module-handbook-postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand-db-prod"
