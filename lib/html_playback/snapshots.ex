defmodule HtmlPlayback.Snapshots do
  alias HtmlPlayback.Schemas.Session
  alias HtmlPlayback.Schemas.SnapshotGroup
  alias HtmlPlayback.Sessions

  @snapshots_bucket "snapshots"

  def list(%Session{} = session) do
    session
    |> Sessions.list_snapshot_group_keys()
    |> Enum.flat_map(&fetch_group(&1).snapshots)
    |> Enum.sort(fn x, y -> x.timestamp <= y.timestamp end)
  end

  def create_snapshot_group(site_id, session_id, snapshots) do
    snapshot_group =
      snapshots
      |> extract_timestamps()
      |> Map.merge(%{snapshots: snapshots, site_id: site_id, session_id: session_id})

    SnapshotGroup
    |> struct(snapshot_group)
    |> create_snapshot_group()
  end

  def create_snapshot_group(%SnapshotGroup{} = snapshot_group) do
    # This is a little weird but I'd come back to this
    case snapshot_group |> Sessions.key() |> Sessions.fetch() do
      nil ->
        Sessions.create(%Session{
          id: snapshot_group.session_id,
          site_id: snapshot_group.site_id,
          snapshot_group_keys: [key(snapshot_group)]
        })

      session ->
        Sessions.add_snapshot_group_key(session, key(snapshot_group))
    end

    Riak.Object.create(bucket: @snapshots_bucket, key: key(snapshot_group), data: snapshot_group)
    |> Riak.put()
    |> Map.get(:data)
  end

  def fetch_group(key) do
    Riak.find(@snapshots_bucket, key)
    |> deserialize()
  end

  def delete_group(key) do
    Riak.delete(@snapshots_bucket, key)
  end

  def key(%{
        site_id: site_id,
        session_id: session_id,
        initial_timestamp: initial_timestamp,
        final_timestamp: final_timestamp
      }),
      do: "#{site_id}_#{session_id}_#{initial_timestamp}:#{final_timestamp}"

  defp deserialize(%{data: data}), do: :erlang.binary_to_term(data)

  defp extract_timestamps(snapshots) do
    sorted_snapshots = Enum.sort(snapshots, fn x, y -> x.timestamp <= y.timestamp end)

    %{
      initial_timestamp: hd(sorted_snapshots).timestamp,
      final_timestamp: List.last(sorted_snapshots).timestamp
    }
  end
end
