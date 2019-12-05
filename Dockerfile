FROM ruby:2.6-alpine

RUN mkdir /app
WORKDIR /app

ADD Gemfile /app/
RUN apk add --update \
  build-base \
  mariadb-dev \
  sqlite-dev \
  && rm -rf /var/cache/apk/*
RUN bundle install -j 8

ADD . /app
