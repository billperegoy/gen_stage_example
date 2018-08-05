defmodule PhotoQueue do
  use GenStage

  def start_link() do
    GenStage.start_link(PhotoQueue, {:queue.new(), 0})
  end

  def init(state) do
    {:producer, state}
  end

  def handle_demand(demand, {queue, unmet_demand}) when demand == 1 do
    process_demand(demand, {queue, unmet_demand})
  end

  def process_demand(demand, {queue, unmet_demand}) do
    if :queue.len(queue) > 0 do
      {{:value, item_to_process}, new_queue} = :queue.out(queue)
      {:noreply, [item_to_process], {new_queue, unmet_demand}}
    else
      {:noreply, [], {queue, unmet_demand + demand}}
    end
  end

  def handle_cast({:add, item}, {queue, unmet_demand}) do
    new_queue = :queue.in(item, queue)

    if unmet_demand > 0 do
      {{:value, item_to_process}, newer_queue} = :queue.out(new_queue)
      {:noreply, [item_to_process], {newer_queue, unmet_demand - 1}}
    else
      {:noreply, [], {new_queue, unmet_demand}}
    end
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
