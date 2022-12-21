# README

## tl;dr: Quick start with an existing dump
(other options below)

Preparation:
- install docker: https://docs.docker.com/get-docker/
- create a new directory.
- Put the dump in it with the name module-handbook.pgdump

git clone git@github.com:modulehandbook/modulehandbook.git

cd modulehandbook
make start
make file=../module-handbook.pgdump init

open http://localhost:3000

---

This is a [Ruby on Rails](https://rubyonrails.org) application using a
[MariaDB Database](https://mariadb.org/) and Devise for Authentication
([heartcombo/devise: Flexible authentication solution for Rails with Warden.](https://github.com/heartcombo/devise)).

[Bootstrap](https://getbootstrap.com) is used for the frontend.

The Modulehandbook is being designed and developed by a team within the joint project
[German International University of Applied Sciences (GIU AS) - Hochschule für Technik und Wirtschaft Berlin University of Applied Sciences - HTW Berlin](https://www.htw-berlin.de/forschung/online-forschungskatalog/projekte/projekt/?eid=2839)
in order to ease collaborative editing of the study programs for the GIU AS.

## Start Locally

    make start

The [makefile](./makefile) contains useful commands; have a look at it.
`make start` uses docker-compose up to start up the docker containers
  - module-handbook
  - module-handbook-exporter
  - module-handbook-mariadb
It uses the Exporter specified in TAG_MODULE_HANDBOOK_EXPORTER set in the makefile.

## Set up Database

**see the [makefile](./makefile) for details and settings**

You can either create a new database with seed data or import a db dump:

- Seed Data: `make new_db`
- Import Dump:
1. with makefile: `make file=<dumpfile> import_dump`
2. Manually
- copy the db dump to ./pg_transfer which is mounted to
      cp <dump-source> ./pg_transfer/uas-module-handbook-cron-2022-11-23--13-00-00.pgdump
- open bash in pg container
      make bash_db
- restore the database: (alter the file name as needed!)
      pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand-dev /var/lib/postgresql/transfer/uas-module-handbook-cron-2022-11-23--13-00-00.pgdump


import for prod db:
DBNAME=modhand-db-prod file=../uas-module-handbook-cron-2022-11-28--22-00-00.pgdump make import_dump

## Devise Authentication Setup

The Modulehandbook uses Devise for Authentication. New Users can register
on the site themselves, but need to be approved by any admin (an existing user
with role 'admin'). Furthermore, they need to confirm their email.

For this to work devise needs an email account configured for actionmailer.
Create an email-Account and set these environment variables:

```
export HOSTNAME=
export DEVISE_EMAIL=
export SMTP_PORT=465
export SMTP_SERVER=smtp.strato.de
export SMTP_LOGIN=
export SMTP_PASSWORD=
```


## Starting the app locally

```bash
bundle install
rails server
```
This needs an open local MariaDB running.
Start mariaDB in docker container:
```bash
docker-compose -f docker-compose.yml up -d module-handbook-mariadb
```

See the [makefile](./makefile) for more useful commands.

### Start in docker container

     docker-compose up
     make new_db

## Set up server on Heroku with seeded database

### Set up heroku server

```
heroku create
git push heroku master
heroku run rails db:migrate
heroku open

```

### Set up mailer for devise
Devise sends emails to confirm new users and for password resets.


```
 heroku config:set HOSTNAME=modulehandbook.server.com
 heroku config:set SMTP_PORT=587
 heroku config:set SMTP_SERVER=smtp.server.de
 heroku config:set SMTP_LOGIN=email@server.com
 heroku config:set SMTP_PASSWORD=geheim
 heroku config:set DEVISE_EMAIL=email@server.com
```

### Seed the database

```
heroku config:set SEED_USER_PW=<pw for users in seed>
heroku run rails db:seed RAILS_ENV=staging
```

(use RAILS_ENV=staging to avoid sending user creation email. This works on
heroku as heroku overwrites and environment db config)

The seeds creates an example program for International Media and Computation at
HTW Berlin with one user within each role. See [db/seeds.rb](db/seeds.rb)

   ['admin@mail.de', :admin],
   ['reader@mail.de', :reader],
   ['writer@mail.de', :writer],
   ['editor@mail.de', :editor],
   ['qa@mail.de', :qa]

# Further Admin Info

## Dumps
dumps are made with pg_dump -fC (special file format) which can be restored with pg_restore

- create production dump: `make dump_production`

creates a file like ../mh-dumps/htw/modhand-2022-12-08--22-48-27.pgdump

- import to local dev db: `make import_dump_local`, e.g.
```bash
DBNAME=modhand-db-dev file=../mh-dumps/htw/modhand-2022-12-08--22-48-27.pgdump make import_dump_local
```


## Import Heroku Dump

Manually, with the dumps mount in place and a current dump copied there:
  docker-compose exec postgresql bash
  pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand /var/lib/postgresql/dumps/uas-module-handbook-cron-2020-12-06--14-00-00.pgdump

or, use this for the container (also in makefile)

    docker-compose exec postgresql pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand /var/lib/postgresql/$(file)

## Heroku Deployment for GIU AS

### Automatic Deployment to Staging

(Automation is done by heroku, see https://dashboard.heroku.com/apps/module-handbook-staging/deploy/github)

Everything in the branch staging is automatically deployed on the staging server. To trigger the automatic deployment to http://module-handbook-staging.herokuapp.com/ use the following steps:

    git checkout staging
    git pull origin master
    git push


### Automatic Deployment to Production

(Automation is done by heroku, see https://dashboard.heroku.com/apps/module-handbook/deploy/github)

Everything in the branch release is automatically deployed on the production server. To trigger the automatic deployment to http://module-handbook.herokuapp.com/ use the following steps:

    git checkout release
    git pull origin master
    git push

### Push directly to heroku

    git push heroku master

### Migration on Heroku

    heroku run rake db:migrate


### Heroku DB Backups

    heroku pg:backups:capture
    heroku pg:backups:download

(now automatically on one macos via crontab:)

    0 * * * * bash && cd /Users/kleinen/mine/current/code/uas-module-handbook/module-handbook && make crondump

## Running the Test suite

    rails test
    rails test:system


    rails test test/** - runs all tests.

## Test Coverage

    rails test

generates test coverage. does not work properly when calling rake/rake test

## added bootstrap with webpack
yarn add bootstrap jquery popper.js


# Deployment to HTW server with Github actions

## Docker and Docker Compose
The Dockerfile contains three targets. modhand-dev contains dev and test
dependencies which are not needed in production.

 - modhand-base
 - modhand-prod
 - modhand-dev

```
docker build --target modhand-prod .
```

local startup in prod environment:

```
docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.localprod.yml up
```

see the makefile for various start/stop and database setup commands.

### Notes for Docker running on Windows machines
Git on windows automatically checks out all files from a Github repository with [CRLF line separator](https://www.aleksandrhovhannisyan.com/blog/crlf-vs-lf-normalizing-line-endings-in-git/) which is problematic when building the docker image locally which runs on a linux machine, and creates a fatal error.

To disable this 'feature' before checking out repository
```
git config --global core.autocrlf false
```

If the files were already checked out, make sure to change [docker-entrypoint.sh](entrypoints/docker-entrypoint.sh) file and [rails](bin/rails) file to the LF line separator before building the image.

This can be done through several IDEs, or even through Notepad++(Edit -> EOL Conversion -> Unix)


# Useful commands on the servers

sudo docker-compose up
sudo docker-compose down

docker stop module-handbook
docker-compose exec module-handbook bash
docker restart modulehandbook
docker ps



# Schema

[https://dbdiagram.io/d/639efdd399cb1f3b55a213d3](https://dbdiagram.io/d/639efdd399cb1f3b55a213d3)

![](https://dbdiagram.io/embed/639efdd399cb1f3b55a213d3)
<iframe width="560" height="315" src='https://dbdiagram.io/embed/639efdd399cb1f3b55a213d3'> </iframe>
