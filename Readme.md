# MySQL information_schema dump

This tool takes all the tables/views/triggers/procedures/functions/events from databases and schemas. This can be useful to automatically track/tag changes to the schema over time.

## Running locally

To run this locally:

```
$ docker-compose build app
Building app
Step 1/7 : FROM ruby:2.6-alpine
 ---> 3304101ccbe9
Step 2/7 : RUN mkdir /app
 ---> Using cache
 ---> 4d520e2791df
Step 3/7 : WORKDIR /app
 ---> Using cache
 ---> d9c1d0ffce92
Step 4/7 : ADD Gemfile /app/
 ---> Using cache
 ---> 5a6ddf34ab23
Step 5/7 : RUN apk add --update   build-base   mariadb-dev   sqlite-dev   && rm -rf /var/cache/apk/*
 ---> Using cache
 ---> c1cca5567c19
Step 6/7 : RUN bundle install -j 8
 ---> Using cache
 ---> d6ad6f482da3
Step 7/7 : ADD . /app
 ---> 892e093c5823
Successfully built 892e093c5823
```

and then go inside it to run the dump
```
docker-compose run app /bin/sh
/app # ruby dump.rb
Connecting to pretty-hostname1
Connecting to pretty-hostname2
```

Once this is done you can navigate in the new `./server/` folder and have a look.

## Todo
Automate a git commit/tag

## Running on a CI/CD pipeline
TBD.

## Sample database.yml file structure
```yml
---
pretty-hostname1:
  ip: 127.0.0.1
  schemas:
  - one_schema
pretty-hostname2:
  ip: 127.0.0.1
  schemas:
  - second_schema
  - third_schema

```
