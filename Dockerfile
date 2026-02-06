FROM ruby:3.2

# Node.js をインストール
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  curl

# Node.js (v18) & Yarn をインストール
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Yarn は corepack 経由で有効にする
RUN corepack enable

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install

COPY . /app
