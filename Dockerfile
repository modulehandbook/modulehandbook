ARG RUBY_VERSION=3.3.6
FROM docker.io/library/ruby:$RUBY_VERSION-alpine AS  modhand-base

ENV MODHAND_IMAGE=modhand-base
ENV BUNDLER_VERSION=2.3.24

ENV RAILS_ENV=production
ENV NODE_ENV=production

WORKDIR /module-handbook
COPY Gemfile Gemfile.lock ./

ENV GENERAL_DEPS="bash gcompat libpq tzdata nodejs yarn"
ENV BUILD_DEPS="git linux-headers libpq libxml2-dev libxslt-dev build-base postgresql-dev"
ENV NOKOGIRI_SYSTEM_LIBS="build-base libxml2-dev libxslt-dev"
ENV AO="--no-install-recommends --no-cache"
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
  && yarn install \
  && apk del builddependencies

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]

# -------------------------------------------------------------------
# Production
# -------------------------------------------------------------------

FROM modhand-base AS modhand-prod
ENV MODHAND_IMAGE=modhand-prod

COPY . ./
RUN --mount=type=secret,id=rails_master_key,env=RAILS_MASTER_KEY \
  set -ex  \
  && yarn install \
  && RAILS_MASTER_KEY=/run/secrets/rails_master_key \
  rails assets:precompile

# -------------------------------------------------------------------
# Development & Test
# -------------------------------------------------------------------

FROM modhand-base AS modhand-dev
ENV MODHAND_IMAGE=modhand-dev

ENV RAILS_ENV=development
ENV NODE_ENV=development

RUN bundle config unset without \
    && bundle config \
    && apk add git \
    && bundle install
# git can and should be removed if 
# capybara is switched back to regular version
