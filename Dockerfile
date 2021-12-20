# new dockerfile from https://www.digitalocean.com/community/tutorials/containerizing-a-ruby-on-rails-application-for-development-with-docker-compose-de
#  docker build --target modhand-prod -t modhandbook/modhandbook-prod:latest .

FROM ruby:2.7.2-alpine AS modhand-base

ENV BUNDLER_VERSION=2.2.30

ENV RAILS_ENV production
ENV NODE_ENV production

# general dependencies
RUN apk update
RUN set -ex \
  && apk add --no-cache libpq nodejs bash gcompat \
  && gem install bundler -v 2.2.30

WORKDIR /module-handbook
COPY Gemfile Gemfile.lock ./
RUN bundle config build.nokogiri --use-system-libraries

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
  tzdata \
  yarn \
  && bundle install --without development test


COPY package.json yarn.lock ./
RUN yarn install --check-files

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]




FROM modhand-base AS modhand-prod

RUN set -ex && \
  apk del builddependencies




FROM modhand-base AS modhand-dev

ENV RAILS_ENV development
ENV NODE_ENV development

COPY . ./
RUN bundle config --delete without && \
    bundle install && \
    yarn install --check-files

RUN set -ex && \
  apk del builddependencies && \
  apk add --no-cache  firefox
