defmodule PhotoQueue do
  use GenStage

  def start_link() do
    queue = :queue.new()
    GenStage.start_link(PhotoQueue, queue)
  end

  def init(queue) do
    IO.puts("Init...")
    {:producer, queue}
  end

  def handle_demand(demand, queue) when demand > 0 do
    # FIXME - assume demand is always 1 to start
    {{:value, item_to_process}, queue} = :queue.out(queue)
    {:noreply, item_to_process, queue}
  end

  def handle_cast({:add, item}, queue) do
    {:noreply, [], :queue.in(item, queue)}
  end

  def handle_call(:list, _from, queue) do
    {:reply, :queue.to_list(queue), [], queue}
  end

  # Public API
  def add(pid, item) do
    GenStage.cast(pid, {:add, item})
  end

  def list(pid) do
    GenStage.call(pid, :list)
  end
end