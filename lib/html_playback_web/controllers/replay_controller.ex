defmodule HtmlPlaybackWeb.ReplayController do
  use HtmlPlaybackWeb, :controller

  def show(conn, _params) do
    render(conn, "replay.html")
  end
end
