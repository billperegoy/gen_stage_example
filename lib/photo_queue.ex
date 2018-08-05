defmodule PhotoQueue do
  use GenStage

  def start_link() do
    GenStage.start_link(PhotoQueue, {:queue.new(), 0})
  end

  def init(state) do
    {:producer, state}
  end

  # FIXME - after queue is empty, we nom longer process new elements
  def handle_demand(demand, {queue, unmet_demand}) when demand == 1 do
    if :queue.len(queue) > 0 do
      {{:value, item_to_process}, new_queue} = :queue.out(queue)
      {:noreply, [item_to_process], {new_queue, unmet_demand}}
    else
      {:noreply, [], {queue, unmet_demand + demand}}
    end
  end

  def handle_cast({:add, item}, {queue, unmet_demand}) do
    {:noreply, [], {:queue.in(item, queue), unmet_demand}}
  end

  def handle_call(:list, _from, {queue, unmet_demand}) do
    {:reply, :queue.to_list(queue), [], {queue, unmet_demand}}
  end

  # Public API
  def add(pid, item) do
    GenStage.cast(pid, {:add, item})
  end

  def list(pid) do
    GenStage.call(pid, :list)
  end
end
