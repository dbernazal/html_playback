defmodule HtmlPlaybackWeb.ReplayPlayerController do
  use HtmlPlaybackWeb, :controller
  alias Phoenix.LiveView

  plug :put_layout, "basic.html"

  def show(conn, _params) do
    LiveView.Controller.live_render(conn, HtmlPlaybackWeb.ReplayPlayerView, session: %{})
  end
end
