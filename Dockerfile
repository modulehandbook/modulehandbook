# new dockerfile from https://www.digitalocean.com/community/tutorials/containerizing-a-ruby-on-rails-application-for-development-with-docker-compose-de

FROM ruby:2.7.2-alpine AS modhand-prod

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
  pkg-config \
  postgresql-dev \
  tzdata \
  yarn \
  && bundle install --without development test \



COPY package.json yarn.lock ./

RUN yarn install --check-files

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]

FROM modhand-prod AS modhand-dev

# only for dev/test
ENV RAILS_ENV development
ENV NODE_ENV development

COPY . ./
RUN bundle install
RUN yarn install --check-files

RUN set -ex \
  && apk add --no-cache  \
  firefox \
  && apk del builddependencies
