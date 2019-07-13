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
      timestamp: 1_563_043_146_071
    },
    %{
      value:
        ~s(<ul><div><div style="background-color: green;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: green;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: green;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div></ul>),
      timestamp: 1_563_043_266_563
    },
    %{
      value:
        ~s(<ul><div><div style="background-color: blue;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: red;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: blue;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div></ul>),
      timestamp: 1_563_043_267_780
    },
    %{
      value:
        ~s(<ul><div><div style="background-color: blue;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: red;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: green;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div></ul>),
      timestamp: 1_563_043_272_139
    },
    %{
      value:
        ~s(<ul><div><div style="background-color: blue;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: red;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div><div><div style="background-color: blue;"><span style="color: white;">This is some color</span></div><button>Red</button><button>Blue</button><button>Green</button></div></ul>),
      timestamp: 1_563_043_274_853
    }
  ]
  def render(assigns) do
    HtmlPlaybackWeb.PageView.render("replay_player.html", assigns)
  end

  def handle_event("play", _value, socket) do
    send(self(), {:render_snapshot, @snapshots})
    {:noreply, assign(socket, snapshot_value: "Starting to render...")}
  end

  def handle_info({:render_snapshot, [%{value: value} | rest] = _snapshots}, socket) do
    Process.send_after(self(), {:render_snapshot, rest}, 500)
    {:noreply, assign(socket, snapshot_value: value)}
  end

  def handle_info({:render_snapshot, []}, socket) do
    # {:noreply, assign(socket, snapshot_value: "Rendering complete")}
    {:noreply, socket}
  end

  def mount(_session, socket) do
    {:ok, assign(socket, snapshot_value: "")}
  end
end
