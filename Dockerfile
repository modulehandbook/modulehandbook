FROM ruby:3.1.2-alpine AS modhand-base

ENV MODHAND_IMAGE=modhand-base
ENV BUNDLER_VERSION=2.3.24

ENV RAILS_ENV production
ENV NODE_ENV production

WORKDIR /module-handbook
COPY Gemfile Gemfile.lock ./

ENV GEN_DEPS bash gcompat libpq tzdata
ENV BUILD_DEPS git linux-headers libpq libxml2-dev libxslt-dev build-base postgresql-dev
ENV NOKOGIRI_SYSTEM_LIBS build-base libxml2-dev libxslt-dev
ENV JS_RUNTIME nodejs
ENV AO --no-install-recommends --no-cache
# general dependencies
RUN apk update \
  && set -ex \
  && apk add $AO $GEN_DEPS \
  && apk add $AO --virtual builddependencies $BUILD_DEPS \
  && apk add $AO --virtual jsruntime $JS_RUNTIME \
  && apk add $AO $NOKOGIRI_SYSTEM_LIBS \
  && gem install nokogiri --platform=ruby -- --use-system-libraries \
  && gem install bundler -v $BUNDLER_VERSION \
  && bundle config set force_ruby_platform true \
  && bundle config set --local without 'development test' \
  && bundle install  \
  && apk del builddependencies

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]

# -------------------------------------------------------------------
# Production
# -------------------------------------------------------------------

FROM modhand-base AS modhand-prod
ENV MODHAND_IMAGE=modhand-prod
ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY $RAILS_MASTER_KEY

COPY . ./

RUN set -ex  \
  && rails assets:precompile \
  && apk del jsruntime

# -------------------------------------------------------------------
# Development
# -------------------------------------------------------------------

FROM modhand-base AS modhand-dev
ENV MODHAND_IMAGE=modhand-dev

ENV RAILS_ENV development
ENV NODE_ENV development

RUN bundle config --local --delete without \
    && bundle install

RUN set -ex  \
  && apk add $AO  firefox
