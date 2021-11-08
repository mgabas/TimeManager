FROM elixir:latest

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && \
  apt-get install -y postgresql-client nodejs

RUN apt install -y netcat

RUN mkdir /api
COPY . /api
WORKDIR /api


RUN mix local.hex --force
RUN mix deps.get
RUN mix local.rebar --force
# RUN cd assets && npm install -f && node node_modules/webpack/bin/webpack.js --mode development
CMD ["/api/entrypoint.sh"]