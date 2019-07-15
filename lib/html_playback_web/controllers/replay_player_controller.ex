defmodule HtmlPlaybackWeb.ReplayPlayerController do
  use HtmlPlaybackWeb, :controller
  alias Phoenix.LiveView

  plug :put_layout, "basic.html"

  def show(conn, %{"session_id" => session_id, "site_id" => site_id}) do
    session = %HtmlPlayback.Schemas.Session{id: session_id, site_id: site_id}

    LiveView.Controller.live_render(conn, HtmlPlaybackWeb.ReplayPlayerView,
      session: %{snapshots: HtmlPlayback.Snapshots.list(session)}
    )
  end
end
