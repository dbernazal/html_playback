defmodule HtmlPlaybackWeb.ReplayPlayerView do
  use Phoenix.LiveView

  def render(assigns) do
    HtmlPlaybackWeb.PageView.render("replay_player.html", assigns)
  end

  def handle_event("play", _value, socket) do
    send(self(), {:render_snapshot, socket.assigns.snapshots})
    {:noreply, assign(socket, snapshot_value: "Starting to render...")}
  end

  def handle_info(
        {:render_snapshot,
         [
           %{value: value, timestamp: initial_timestamp},
           %{timestamp: final_timestamp} = second | rest
         ] = _snapshots},
        socket
      ) do
    # We need to calculate when to render the next snapshot
    # We do this by taking the difference between the next two snapshots
    # and then triggering the next render according to the diff
    time_diff = time_diff_in_milliseconds(initial_timestamp, final_timestamp)
    Process.send_after(self(), {:render_snapshot, [second | rest]}, time_diff)

    {:noreply, assign(socket, snapshot_value: value)}
  end

  def handle_info({:render_snapshot, [%{value: value}]}, socket) do
    {:noreply, assign(socket, snapshot_value: value)}
  end

  def handle_info({:render_snapshot, _rest}, socket) do
    {:noreply, assign(socket, snapshot_value: "<h1>Replay complete!</h1>")}
  end

  def mount(%{snapshots: snapshots}, socket) do
    updated_socket =
      socket
      |> assign(snapshot_value: "")
      |> assign(snapshots: snapshots)

    {:ok, updated_socket}
  end

  defp time_diff_in_milliseconds(initial_timestamp, final_timestamp),
    do: final_timestamp - initial_timestamp
end
