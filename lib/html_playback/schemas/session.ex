defmodule HtmlPlayback.Schemas.Session do
  @enforce_keys [:id, :site_id]
  defstruct id: nil, site_id: nil, snapshot_group_keys: nil
end
