FROM ruby:2.7.1-alpine3.11
RUN apk update
RUN set -ex \
  && apk add --no-cache libpq nodejs bash gcompat git

RUN mkdir /module-handbook
WORKDIR /module-handbook
COPY Gemfile /module-handbook/Gemfile
COPY Gemfile.lock /module-handbook/Gemfile.lock

RUN set -ex \
   && apk add --no-cache --virtual builddependencies \
       linux-headers \
       tzdata \
       build-base \
       postgresql-dev
RUN gem install bundler \
   && bundle install
RUN apk del builddependencies

COPY . /module-handbook

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "unicorn", "--port", "3000"]
