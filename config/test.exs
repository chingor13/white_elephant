use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :white_elephant, WhiteElephantWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :white_elephant, WhiteElephant.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "white_elephant_test",
  hostname: "/cloud_sql_proxy/chingor-php-gcs:us-central1:postgres-1",
  pool: Ecto.Adapters.SQL.Sandbox
