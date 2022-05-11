FROM elixir

WORKDIR /app

# install package manager
RUN mix local.hex --force
RUN mix local.rebar --force

# install phoenix cli
RUN mix archive.install hex phx_new --force