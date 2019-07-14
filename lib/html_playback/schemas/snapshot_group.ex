defmodule HtmlPlayback.SnapshotGroup do
  @enforce_keys [
    :initial_timestamp,
    :final_timestamp,
    :snapshots,
    :site_id,
    :session_id
  ]
  defstruct snapshots: [],
            initial_timestamp: nil,
            final_timestamp: nil,
            site_id: nil,
            session_id: nil
end
