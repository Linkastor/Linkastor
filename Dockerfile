FROM ruby:2.2.3

MAINTAINER Thibaut Le Levier <thibaut@lelevier.fr>

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /linkastor
WORKDIR /linkastor

ADD Gemfile /linkastor/Gemfile
ADD Gemfile.lock /linkastor/Gemfile.lock
RUN bundle install --without production

RUN gem install foreman

EXPOSE 5000

ADD . /linkastor