defmodule HtmlPlayback.Schemas.Site do
  @enforce_keys [:id, :name]
  defstruct id: nil, name: nil, url: nil
end
