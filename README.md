# README

This is a [Ruby on Rails](https://rubyonrails.org) application using a
[Postgres Database](https://www.postgresql.org) and Devise for Authentication
([heartcombo/devise: Flexible authentication solution for Rails with Warden.](https://github.com/heartcombo/devise)).

[Bootstrap](https://getbootstrap.com) is used for the frontend.

It was and is being designed and developed by a team within the joint project
[German International University of Applied Sciences (GIU AS) - Hochschule für Technik und Wirtschaft Berlin University of Applied Sciences - HTW Berlin](https://www.htw-berlin.de/forschung/online-forschungskatalog/projekte/projekt/?eid=2839)


## Starting the app locally

With a local Postgres running

     rails s

Without a local Postgres running

     docker-compose up

## Import Heroku Dump

Manually, with the dumps mount in place and a current dump copied there:
  docker-compose exec postgresql bash
  pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand /var/lib/postgresql/dumps/uas-module-handbook-cron-2020-12-06--14-00-00.pgdump

or, use this for the container (also in makefile)

    docker-compose exec postgresql pg_restore --verbose --clean --no-acl --no-owner -h localhost -U modhand -d modhand /var/lib/postgresql/$(file)

## Heroku Deployment for GIU AS

### Automatic Deployment to Staging

Everything in the branch staging is automatically deployed on the staging server. To trigger the automatic deployment to http://module-handbook-staging.herokuapp.com/ use the following steps:

    git checkout staging
    git pull origin master
    git push


### Automatic Deployment to Production

Everything in the branch release is automatically deployed on the production server. To trigger the automatic deployment to http://module-handbook.herokuapp.com/ use the following steps:

    git gheckout release
    git pull origin master
    git push

### Push directly to heroku

    git push heroku master

### Migration on Heroku

    heroku run rake db:migrate


### Heroku DB Backups

    heroku pg:backups:capture
    heroku pg:backups:download

(now automatically on macos via crontab:)

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
  (done)


### devise on heroku
heroku config:set DEVISE_SECRET_KEY=xyz

### emails

- set up emails with private account and plain smtp.

### Devise Require admin to activate account before sign_in

https://github.com/heartcombo/devise/wiki/How-To:-Require-admin-to-activate-account-before-sign_in
