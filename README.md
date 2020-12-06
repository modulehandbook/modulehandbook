# README


## Starting the app locally

### With Postgres 12.2:

     make startdb **ODER** docker-compose up postgresql -d
     rails s

then visit http://localhost:3000/


### With Postgres 11.7:

    make startdb_11 **ODER** docker-compose up postgresql-11
    rails s

then visit http://localhost:3000/

## Import Heroku Dump

Manually, with the dumps mount in place and a current dump copied there:
  docker-compose exec postgresql bash
  pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand /var/lib/postgresql/dumps/uas-module-handbook-cron-2020-12-06--14-00-00.pgdump

or, use this for the container (also in makefile)

    docker-compose exec postgresql pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand /var/lib/postgresql/$(file)

## Heroku Deployment

https://devcenter.heroku.com/articles/getting-started-with-rails6#migrate-your-database

    git push heroku master
    heroku run rake db:migrate


https://devcenter.heroku.com/articles/heroku-postgres-backups

https://devcenter.heroku.com/articles/heroku-postgres-import-export

### Heroku DB Backups

    heroku pg:backups:capture
    heroku pg:backups:download

(now automatically on macos via crontab:)

    0 * * * * bash && cd /Users/kleinen/mine/current/code/uas-module-handbook/module-handbook && make crondump


## added bootstrap with webpack
yarn add bootstrap jquery popper.js



## devise notes

Some setup you must do manually if you haven't yet:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in config/environments/development.rb:

       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

     In production, :host should be set to the actual host of your application.
  (done)
  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"
  (done)
  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>
  (done)
  4. You can copy Devise views (for customization) to your app by running:

       rails g devise:views
  (not done)


### devise on heroku
heroku config:set DEVISE_SECRET_KEY=xyz

### emails

- set up emails with private account and plain smtp.

### Devise Require admin to activate account before sign_in

https://github.com/heartcombo/devise/wiki/How-To:-Require-admin-to-activate-account-before-sign_in
