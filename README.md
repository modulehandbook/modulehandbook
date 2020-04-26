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

### configured MailGun

https://devcenter.heroku.com/articles/mailgun

ActionMailer::Base.smtp_settings = {
  :port           => ENV['MAILGUN_SMTP_PORT'],
  :address        => ENV['MAILGUN_SMTP_SERVER'],
  :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
  :password       => ENV['MAILGUN_SMTP_PASSWORD'],
  :domain         => 'module-handbook.heroku.com',
  :authentication => :plain,
}
ActionMailer::Base.delivery_method = :smtp


### devise on heroku
heroku config:set DEVISE_SECRET_KEY=xyz

### emails

~/mine/current/code/uas-module-handbook/module-handbook (devise)$ heroku addons:create sendgrid:starter
Creating sendgrid:starter on ⬢ module-handbook... free
Created sendgrid-curly-59499 as SENDGRID_PASSWORD, SENDGRID_USERNAME
Use heroku addons:docs sendgrid to view documentation
~/mine/current/code/uas-module-handbook/module-handbook (devise)


### send mail from console
mailer = ActionMailer::Base.new

# check settings:
mailer.delivery_method # -> :smtp
mailer.smtp_settings # -> { address: "localhost", port: 25, domain: "localhost.localdomain", user_name: nil, password: nil, authentication: nil, enable_starttls_auto: true }

# send mail:
mailer.mail(from: 'sender@example.com', to: 'recipient@example.com', subject: 'test', body: "Hello, you've got mail!").deliver

Growing Rails Applications in Practice
