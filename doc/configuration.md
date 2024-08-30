


# Overview

# bin/rails credentials:edit

Rails.application.credentials.devise.secret_key

EDITOR="code --wait" bin/rails credentials:edit -e production
EDITOR="code --wait" bin/rails credentials:edit -e staging


https://thoughtbot.com/blog/switching-from-env-files-to-rails-credentials

config/credentials/development.yml.enc
config/credentials.yml.enc


RAILS_ENV=staging bin/rails credentials:edit
RAILS_ENV=production bin/rails credentials:edit


EDITOR="code --wait" bin/rails credentials:edit
EDITOR="code --wait" bin/rails credentials:edit -e production

-e 

bin/rails credentials:edit -e development

bin/rails credentials:diff --enroll

SMTP_LOGIN=
SMTP_PASSWORD=
SMTP_PORT=
SMTP_SERVER=smtp_dummy


ENV['DEVISE_SECRET_KEY']

devise_key: 

https://edgeguides.rubyonrails.org/security.html#custom-credentials
