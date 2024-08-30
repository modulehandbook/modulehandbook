

# Overview

## Credentials

Alle credentials mit (Ausnahme  des Master-Keys) sind 
in den rails credentials für die entsprechenden environments:

development.key
development.yml.enc
production.key
production.yml.enc
staging.key
staging.yml.enc

die keys müssen in .gitignore stehen - auch für development, da auch dort 
eine Mailer-Config drin ist.


### bin/rails credentials:edit


EDITOR="code --wait" bin/rails credentials:edit -e development

EDITOR="code --wait" bin/rails credentials:edit -e staging

EDITOR="code --wait" bin/rails credentials:edit -e production


bin/rails credentials:edit 
(ohne environment) sollte nicht mehr verwendet werden. 

### Notwendige Credentials für Module-Handbook

secret_key_base: xyz

devise:
  secret_key: xyz
  smtp_login: xyz
  smtp_password: xyz
  smtp_port: xyz
  smtp_server: xyz


### Documentation

- https://thoughtbot.com/blog/switching-from-env-files-to-rails-credentials
- https://edgeguides.rubyonrails.org/security.html#custom-credentials

## ENV

TAG_MODULE_HANDBOOK=1.0.3
SECRET_ENV_FILE=secrets/secrets.env
NGINX_CERT=/etc/ssl/production/module-handbook.f4.htw-berlin.de.cer
NGINX_KEY=/etc/ssl/production/module-handbook.f4.htw-berlin.de.key
NGINX_HOST=module-handbook.f4.htw-berlin.de
TAG_MODULE_HANDBOOK_EXPORTER=sha-4ef1b2d
