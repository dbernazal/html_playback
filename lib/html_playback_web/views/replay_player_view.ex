defmodule HtmlPlaybackWeb.ReplayPlayerView do
  use Phoenix.LiveView

  @snapshots [
    %{
      value:
        ~s(<ul><div><div style="background-color: green;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div></ul>),
      timestamp: 1_563_043_146_071
    },
    %{
      value:
        ~s(<ul><div><div style="background-color: green;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: green;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div></ul>),
      timestamp: 1_563_043_155_944
    },
    %{
      value:
        ~s(<ul><div><div style="background-color: green;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: green;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: green;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div></ul>),
      timestamp: 1_563_043_160_573
    },
    %{
      value:
        ~s(<ul><div><div style="background-color: blue;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: red;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: blue;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div></ul>),
      timestamp: 1_563_043_161_803
    },
    %{
      value:
        ~s(<ul><div><div style="background-color: blue;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: red;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: green;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div></ul>),
      timestamp: 1_563_043_165_291
    },
    %{
      value:
        ~s(<ul><div><div style="background-color: blue;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: red;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: blue;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div></ul>),
      timestamp: 1_563_043_167_668
    }
  ]
  def render(assigns) do
    HtmlPlaybackWeb.PageView.render("replay_player.html", assigns)
  end

  def handle_event("play", _value, socket) do
    send(self(), {:render_snapshot, @snapshots})
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

  def handle_info({:render_snapshot, _rest}, socket) do
    # {:noreply, assign(socket, snapshot_value: "Rendering complete")}
    {:noreply, socket}
  end

  def mount(_session, socket) do
    {:ok, assign(socket, snapshot_value: "")}
  end

  defp time_diff_in_milliseconds(initial_timestamp, final_timestamp),
    do: final_timestamp - initial_timestamp
end
