# new dockerfile from https://www.digitalocean.com/community/tutorials/containerizing-a-ruby-on-rails-application-for-development-with-docker-compose-de
#  docker build --target modhand-prod -t modhandbook/modhandbook-prod:latest .

FROM ruby:2.7.2-alpine AS modhand-base

ENV MODHAND_IMAGE=modhand-base
ENV BUNDLER_VERSION=2.3.24

ENV RAILS_ENV production
ENV NODE_ENV production

WORKDIR /module-handbook
COPY . ./
# COPY Gemfile Gemfile.lock ./

# general dependencies
RUN apk update \
  && set -ex \
  && apk add --no-cache bash gcompat libpq nodejs tzdata \
  && gem install bundler -v $BUNDLER_VERSION

# build dependencies
RUN set -ex \
  && apk add --no-cache --virtual builddependencies \
  git \
  linux-headers \
  libpq \
  libxml2-dev \
  libxslt-dev \
  build-base \
  postgresql-dev
# nokogiri
RUN set -ex \
  && apk add --no-cache build-base libxml2-dev libxslt-dev --virtual nokogiridependencies\
  && gem install nokogiri --platform=ruby -- --use-system-libraries

RUN set -ex \
  bundle config set force_ruby_platform true && \
  bundle config set --local without 'development test' && \
  bundle install
RUN set -ex \
  apk del builddependencies nokogiridependencies

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]

# -------------------------------------------------------------------
# Production
# -------------------------------------------------------------------

FROM modhand-base AS modhand-prod
ENV MODHAND_IMAGE=modhand-prod
ARG rails_master_key
ENV RAILS_MASTER_KEY $rails_master_key

RUN set -ex && \
  rails assets:precompile

# -------------------------------------------------------------------
# Development
# -------------------------------------------------------------------

FROM modhand-base AS modhand-dev
ENV MODHAND_IMAGE=modhand-dev

ENV RAILS_ENV development
ENV NODE_ENV development

# COPY . ./

RUN set -ex \
   && bundle config --local --delete without \
  # && bundle config --delete with \
   && bundle install

RUN set -ex && \
  apk add --no-cache  firefox
