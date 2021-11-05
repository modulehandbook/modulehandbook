FROM ruby:2.7.1-alpine3.12
RUN apk update
RUN set -ex \
  && apk add --no-cache libpq nodejs npm bash gcompat git tzdata firefox

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

EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "unicorn", "--port", "3000"]
