export MIX_ENV=prod
mix compile
mix assets.deploy
mix release
