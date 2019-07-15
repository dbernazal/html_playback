defmodule HtmlPlaybackWeb.SnapshotController do
  use HtmlPlaybackWeb, :controller
  require Logger

  alias HtmlPlayback.Snapshots
  alias HtmlPlayback.Schemas.SnapshotGroup

  action_fallback HtmlPlaybackWeb.FallbackController

  def create(conn, %{"snapshots" => snapshots, "site_id" => site_id, "session_id" => session_id}) do
    with %SnapshotGroup{} = snapshot <-
           Snapshots.create_snapshot_group(
             site_id,
             session_id,
             atomize_keys(snapshots)
           ) do
      snapshot
      |> inspect()
      |> Logger.info(ansi_color: :magenta)

      send_resp(conn, :ok, "")
    end
  end

  def create(conn, params) do
    IO.inspect(params, label: "it happened")
    send_resp(conn, :internal_server_error, "")
  end

  # Normally I would use Ecto or another tool to safely
  # convert these but this is just a demo.
  # Taken from https://gist.github.com/kipcole9/0bd4c6fb6109bfec9955f785087f53fb
  @doc """
  Convert map string keys to :atom keys
  """
  def atomize_keys(nil), do: nil

  # Structs don't do enumerable and anyway the keys are already
  # atoms
  def atomize_keys(struct = %{__struct__: _}) do
    struct
  end

  def atomize_keys(map = %{}) do
    map
    |> Enum.map(fn {k, v} -> {String.to_atom(k), atomize_keys(v)} end)
    |> Enum.into(%{})
  end

  # Walk the list and atomize the keys of
  # of any map members
  def atomize_keys([head | rest]) do
    [atomize_keys(head) | atomize_keys(rest)]
  end

  def atomize_keys(not_a_map) do
    not_a_map
  end
end
