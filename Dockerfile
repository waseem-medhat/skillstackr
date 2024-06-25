FROM elixir:latest

EXPOSE 4000

RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get install -y inotify-tools && \
    apt-get install -y nodejs && \
    curl -L https://npmjs.org/install.sh | sh && \
    mix local.hex --force && \
    mix archive.install hex phx_new --force && \
    mix local.rebar --force

COPY . /app

ENV APP_HOME /app
WORKDIR $APP_HOME

RUN mix deps.get

ENTRYPOINT ./entrypoint.sh
