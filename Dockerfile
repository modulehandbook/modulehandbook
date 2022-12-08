# new dockerfile from https://www.digitalocean.com/community/tutorials/containerizing-a-ruby-on-rails-application-for-development-with-docker-compose-de
#  docker build --target modhand-prod -t modhandbook/modhandbook-prod:latest .

FROM ruby:3.1.2-alpine AS modhand-base

ENV MODHAND_IMAGE=modhand-base
ENV BUNDLER_VERSION=2.3.24

ENV RAILS_ENV production
ENV NODE_ENV production

# general dependencies
RUN apk update
RUN set -ex \
  && apk add --no-cache bash gcompat libpq nodejs tzdata \
  && gem install bundler -v 2.3.24

WORKDIR /module-handbook
COPY Gemfile Gemfile.lock ./
RUN bundle config set force_ruby_platform true

# build dependencies
RUN set -ex \
  && apk add --no-cache --virtual builddependencies \
  git \
  linux-headers \
  libpq \
  libxml2-dev \
  libxslt-dev \
  build-base \
  postgresql-dev \
  && bundle config set --local without 'development test' \
  && apk add --no-cache build-base libxml2-dev libxslt-dev \
  && gem install nokogiri --platform=ruby -- --use-system-libraries \
  && bundle install
#  tzdata \



ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]



# -------------------------------------------------------------------
# Production OLD
# -------------------------------------------------------------------

FROM modhand-base AS modhand-prod-1
ENV MODHAND_IMAGE=modhand-prod-1

RUN set -ex && \
  apk del builddependencies



# -------------------------------------------------------------------
# Development
# -------------------------------------------------------------------

FROM modhand-base AS modhand-dev
ENV MODHAND_IMAGE=modhand-dev

ENV RAILS_ENV development
ENV NODE_ENV development

COPY . ./
RUN bundle config --local --delete without && \
    bundle config --local --delete with && \
    bundle install

RUN set -ex && \
  apk del builddependencies && \
  apk add --no-cache  firefox

# -------------------------------------------------------------------
# Production extending dev
# -------------------------------------------------------------------

FROM modhand-dev AS modhand-prod
ENV MODHAND_IMAGE=modhand-prod
ENV RAILS_ENV production
ENV NODE_ENV production
ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY $RAILS_MASTER_KEY
# COPY . ./
RUN set -ex && \
    rails assets:precompile
