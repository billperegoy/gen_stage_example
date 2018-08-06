defmodule PhotoProcessor do
  use GenStage

  def start_link() do
    GenStage.start_link(PhotoProcessor, :nothing)
  end

  def init(state) do
    {:consumer, state}
  end

  def handle_events(events, _from, state) do
    IO.inspect(events, label: "Events being processed")
    Process.sleep(1000)
    {:noreply, [], state}
  end
end
