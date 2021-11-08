#!/bin/bash
# Docker entrypoint script.

# Wait until Postgres is ready
echo "Testing if Postgres is accepting connections. {$PGHOST} {$PGPORT} {$PGUSER}"

until nc -z localhost 5432; do echo "waiting for db"; sleep 1; done

# Create, migrate, and seed database if it doesn't exist.
# if [[ -z psql -Atqc "\\list $PGDATABASE" ]]; then
echo "Database $PGDATABASE does not exist. Creating..."
mix ecto.drop
echo "=================================================================================11111111111111111111111"
mix ecto.create
echo "=================================================================================222222222222222222222222"
mix ecto.migrate
echo "=================================================================================333333333333333333333333"
mix run priv/repo/seeds.exs
echo "Database $PGDATABASE created."
# fi

exec mix phx.server