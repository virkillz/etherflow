# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :etherflow, EtherflowWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FlzJFeC67fUZn8xsiGepOYHEJRxJGcst2dfpYZnD+3nsy0xH4MJJBQGfjOUN2QSs",
  render_errors: [view: EtherflowWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Etherflow.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :bolt_sips, Bolt,
  hostname: 'localhost',
  basic_auth: [username: "neo4j", password: "botoloctopus"],
  port: 7687,
  pool_size: 5,
  max_overflow: 1

config :etherflow,
  url: "https://mainnet.infura.io/v3/fb85ea4c06be41ebb69844eb7504e09d"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
