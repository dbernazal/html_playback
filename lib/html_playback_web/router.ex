defmodule HtmlPlaybackWeb.Router do
  use HtmlPlaybackWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HtmlPlaybackWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/replay", ReplayController, :show
    get "/replay_player", ReplayPlayerController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", HtmlPlaybackWeb do
  #   pipe_through :api
  # end
end
