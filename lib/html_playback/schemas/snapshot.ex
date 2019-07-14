defmodule HtmlPlayback.Snapshot do
  @enforce_keys [:value, :timestamp]
  defstruct value: "", timestamp: nil

  def time_delta(initial, final), do: initial.timestamp - final.timestamp
end
