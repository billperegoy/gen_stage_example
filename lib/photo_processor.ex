defmodule PhotoProcessor do
  use GenStage

  def start_link() do
    GenStage.start_link(PhotoProcessor, :ok)
  end

  def init(state) do
    {:consumer, :nothing}
  end

  def handle_events(events, _from, state) do
    IO.inspect(events, label: "Events being processed")
    Process.sleep(2000)
    IO.puts("Processing done in 2 seconds")
    {:noreply, [], state}
  end
end
