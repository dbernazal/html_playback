defmodule HtmlPlaybackWeb.PageController do
  use HtmlPlaybackWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def example(conn, _params) do
    render(conn, "example.html")
  end
end
