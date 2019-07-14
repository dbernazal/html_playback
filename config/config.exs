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
  pubsub: [name: HtmlPlayback.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "rVeFmJEroV2BBbNads01KTwiMAAcTOAZ34CZa7xP8BFI4yQ9Lobjtc64VtspClID"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix,
  json_library: Jason,
  template_engines: [leex: Phoenix.LiveView.Engine]

config :pooler,
  pools: [
    [
      name: :riaklocal1,
      group: :riak,
      max_count: 10,
      init_count: 5,
      start_mfa: {Riak.Connection, :start_link, []}
    ],
    [
      name: :riaklocal2,
      group: :riak,
      max_count: 15,
      init_count: 2,
      start_mfa: {Riak.Connection, :start_link, []}
    ]
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
