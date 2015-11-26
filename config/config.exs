# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :auth_sandbox, AuthSandbox.Endpoint,
  http: [port: 4000],
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "ffUxr2pxrPfois7U973fUf9UyOy782fcuNDUvJ6HxSiVcwzbl1dg4GS9BMXiQg2n",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: AuthSandbox.PubSub,
           adapter: Phoenix.PubSub.PG2],
  https: [
    port: 4040,
    otp_app: :auth_sandbox,
    keyfile: "priv/localhost_key.pem",
    certfile: "priv/localhost_cert.pem"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
