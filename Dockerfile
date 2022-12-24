FROM ruby:3.1.2-alpine AS modhand-base

ENV MODHAND_IMAGE=modhand-base
ENV BUNDLER_VERSION=2.3.24

ENV RAILS_ENV production
ENV NODE_ENV production

WORKDIR /module-handbook
COPY Gemfile Gemfile.lock ./

ENV GENERAL_DEPS bash gcompat libpq tzdata nodejs mariadb-dev mysql-client
ENV BUILD_DEPS git linux-headers libpq libxml2-dev libxslt-dev build-base
ENV NOKOGIRI_SYSTEM_LIBS build-base libxml2-dev libxslt-dev
ENV AO --no-install-recommends --no-cache
# general dependencies
RUN apk update \
  && set -ex \
  && apk add $AO $GENERAL_DEPS \
  && apk add $AO --virtual builddependencies $BUILD_DEPS \
  && apk add $AO $NOKOGIRI_SYSTEM_LIBS \
  && gem install nokogiri --platform=ruby -- --use-system-libraries \
  && gem install bundler -v $BUNDLER_VERSION \
  && bundle config set force_ruby_platform true \
  && bundle config set without 'development test' \
  && bundle config \
  && bundle install  \
  && apk del builddependencies

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]

# -------------------------------------------------------------------
# Production without assets (for Pull Requests)
# -------------------------------------------------------------------

FROM modhand-base AS modhand-prod-no-assets
ENV MODHAND_IMAGE=modhand-prod-no-assets

COPY . ./

# -------------------------------------------------------------------
# Production
# -------------------------------------------------------------------

FROM modhand-prod-no-assets AS modhand-prod
ENV MODHAND_IMAGE=modhand-prod
ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY $RAILS_MASTER_KEY

RUN set -ex  \
  && rails assets:precompile

# -------------------------------------------------------------------
# Development
# -------------------------------------------------------------------

FROM modhand-base AS modhand-dev
ENV MODHAND_IMAGE=modhand-dev

ENV RAILS_ENV development
ENV NODE_ENV development

RUN bundle config unset without \
    && bundle config \
    && bundle install

RUN set -ex  \
  && apk add $AO  firefox
