ARG RUBY_VERSION=3.1.2
FROM ruby:$RUBY_VERSION

RUN apt-get update && apt-get install -y \
      build-essential \
      locales \
      sudo \
  && apt-get clean

ENV LANG C.UTF-8

RUN mkdir -p /app && chown $USER:$USER /app
WORKDIR /app

RUN gem install bundler