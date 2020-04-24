# README

## Heroku Deployment

https://devcenter.heroku.com/articles/getting-started-with-rails6#migrate-your-database

    git push heroku master
    heroku run rake db:migrate


https://devcenter.heroku.com/articles/heroku-postgres-backups

https://devcenter.heroku.com/articles/heroku-postgres-import-export

heroku pg:backups:capture
heroku pg:backups:download


## added bootstrap with webpack
yarn add bootstrap jquery popper.js



## devise notes

Some setup you must do manually if you haven't yet:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in config/environments/development.rb:

       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

     In production, :host should be set to the actual host of your application.

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

  4. You can copy Devise views (for customization) to your app by running:

       rails g devise:views
