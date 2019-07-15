defmodule HtmlPlaybackWeb.ReplayController do
  use HtmlPlaybackWeb, :controller

  def show(conn, %{"session_id" => session_id, "site_id" => site_id}) do
    render(conn, "replay.html",
      replay_path: Routes.replay_player_url(conn, :show, site_id, session_id)
    )
  end
end
