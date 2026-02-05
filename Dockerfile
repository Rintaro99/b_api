# 1. Ruby を含む公式イメージを使う（Rails は Ruby で動くため）
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

# コンテナ内の作業フォルダを指定
WORKDIR /app

# まず Gemfile をコピーして bundle install（キャッシュ高速化のため）
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

# プロジェクト全体をコピー（Rails new のあと）
COPY . /app


