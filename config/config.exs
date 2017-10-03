# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :white_elephant,
  ecto_repos: [WhiteElephant.Repo]

# Configures the endpoint
config :white_elephant, WhiteElephantWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TGTfFxAsrc8GnsSuSNU15ZWaArRby7OrIcFWPTRmiReM13/2D6Mle8k2ltCm9iBO",
  render_errors: [view: WhiteElephantWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WhiteElephant.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
