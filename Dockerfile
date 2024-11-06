# Rubyバージョン指定
ARG RUBY_VERSION=3.3.5
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Railsアプリケーションの作業ディレクトリを設定
WORKDIR /rails

# 基本パッケージのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# 本番環境用の環境変数を設定
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# ビルド用の一時的なステージ
FROM base AS build

# gemをビルドするために必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Node.jsとYarnのインストール
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && apt-get install -y nodejs && \
    npm install -g yarn

# アプリケーションのGemをインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# アプリケーションコードをコピー
COPY . .

# ブートスナップ用のコードをプリコンパイルして起動時間を短縮
RUN bundle exec bootsnap precompile app/ lib/

# Node.jsの依存関係をインストールしてアセットをビルド
RUN yarn install
RUN yarn build:css

# アセットのプリコンパイル用の環境変数を設定
ENV SECRET_KEY_BASE=dummy-key-for-precompile \
    RAILS_SKIP_SPOTIFY_AUTH=true \
    SPOTIFY_CLIENT_ID=dummy-client-id \
    SPOTIFY_SECRET_ID=dummy-secret-id

# 本番環境用にアセットをプリコンパイル
RUN ./bin/rails assets:precompile

# 最終的なアプリケーションイメージのためのステージ
FROM base

# ビルドしたアーティファクト（gems、アプリケーション）をコピー
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# セキュリティのため、非rootユーザーで実行
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# デフォルトでサーバーを起動（実行時に上書き可能）
EXPOSE 3000
CMD ["./bin/rails", "server"]