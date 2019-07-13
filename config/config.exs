# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :html_playback, HtmlPlaybackWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "51AXe2UgW4ycP/0D1eZ18OWmSR2AVVXqNmVL8ihP+jTu1t/vU9Np6XFqNU7AfQ1t",
  render_errors: [view: HtmlPlaybackWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HtmlPlayback.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
