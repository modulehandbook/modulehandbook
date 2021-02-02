FROM ruby:2.7.1-alpine3.11
RUN apk update
RUN set -ex \
  && apk add --no-cache libpq nodejs bash gcompat git tzdata \
  && apk add  --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/main/ nodejs=8.9.3-r1

# https://github.com/npm/npm/issues/20861
RUN npm config set unsafe-perm true \
  && npm install --global yarn
# install yarn

RUN mkdir /module-handbook
WORKDIR /module-handbook
COPY Gemfile /module-handbook/Gemfile
COPY Gemfile.lock /module-handbook/Gemfile.lock

RUN set -ex \
   && apk add --no-cache --virtual builddependencies \
       linux-headers \
       build-base \
       postgresql-dev
RUN gem install bundler \
   && bundle install
RUN apk del builddependencies

COPY . /module-handbook

# install yarn modules
RUN yarn install --ignore-engines

# Start the main process.
CMD ["bundle", "exec", "unicorn", "--port", "80"]
