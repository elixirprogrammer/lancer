# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :lancer,
  ecto_repos: [Lancer.Repo]

# Configures the endpoint
config :lancer, Lancer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+CnMhzAoc4tL0g4jodKyvv7Cw3WCaBujxWuUjiWW3PFieBhgLeS1MVEX8lL0FPRj",
  render_errors: [view: Lancer.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Lancer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
