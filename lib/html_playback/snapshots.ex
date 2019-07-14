defmodule HtmlPlayback.Snapshots do
  alias HtmlPlayback.Session
  alias HtmlPlayback.Sessions

  @snapshots_bucket "snapshots"

  def list(%Session{} = session) do
    session
    |> Sessions.list_snapshot_group_keys()
    |> Enum.flat_map(&fetch_group(&1).snapshots)
  end

  def create_group(snapshot_group) do
    Riak.Object.create(bucket: @snapshots_bucket, key: key(snapshot_group), data: snapshot_group)
    |> Riak.put()
    |> Map.get(:data)
  end

  def fetch_group(key) do
    Riak.find(@snapshots_bucket, key)
    |> deserialize()
  end

  def key(%{
        site_id: site_id,
        session_id: session_id,
        initial_timestamp: initial_timestamp,
        final_timestamp: final_timestamp
      }),
      do: "#{site_id}_#{session_id}_#{initial_timestamp}:#{final_timestamp}"

  defp deserialize(%{data: data}), do: :erlang.binary_to_term(data)
end
