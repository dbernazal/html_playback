defmodule HtmlPlayback.Sessions do
  alias HtmlPlayback.Session

  @sessions_bucket "sessions"

  def fetch(%Session{} = session) do
    Riak.find(@sessions_bucket, key(session))
    |> deserialize()
  end

  def create(%Session{} = session) do
    Riak.Object.create(bucket: @sessions_bucket, key: key(session), data: session)
    |> Riak.put()
    |> Map.get(:data)
  end

  def update(%Session{} = session) do
    object = Riak.find(@sessions_bucket, key(session))

    Riak.put(%{object | data: session})
    |> Map.get(:data)
  end

  def delete(%Session{} = session) do
    Riak.delete(@sessions_bucket, key(session))
  end

  def list_snapshot_group_keys(session) do
    Riak.find(@sessions_bucket, key(session))
    |> deserialize()
    |> Map.get(:snapshot_group_keys)
  end

  def add_snapshot_group_key(session, snapshot_group_key) do
    session
    |> fetch()
    |> prepend_to_snapshot_group_keys(snapshot_group_key)
    |> update()
  end

  def key(%{site_id: site_id, id: id}), do: site_id <> "_" <> id

  defp deserialize(%{data: data}), do: :erlang.binary_to_term(data)

  defp prepend_to_snapshot_group_keys(
         %{snapshot_group_keys: snapshot_group_keys} = session,
         snapshot_group_key
       ) do
    # This is in reverse chronological order so the list insertion time is fast
    %{session | snapshot_group_keys: [snapshot_group_key | snapshot_group_keys]}
  end
end
