defmodule HtmlPlaybackWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use HtmlPlaybackWeb, :controller

  def call(conn, {:error, _}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(HtmlPlaybackWeb.ErrorView)
    |> render(:"500")
  end
end
