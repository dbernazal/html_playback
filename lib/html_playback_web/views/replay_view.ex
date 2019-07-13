defmodule HtmlPlaybackWeb.ReplayView do
  use HtmlPlaybackWeb, :view

  def render("replay.html", assigns) do
    HtmlPlaybackWeb.PageView.render("replay.html", assigns)
  end
end
