defmodule GenStageExampleTest do
  use ExUnit.Case
  doctest GenStageExample

  test "initializes with an empty queue" do
    {:ok, pid} = PhotoQueue.start_link()

    assert PhotoQueue.list(pid) == []
  end

  test "adds items to queue successfully" do
    {:ok, pid} = PhotoQueue.start_link()
    PhotoQueue.add(pid, "first")
    PhotoQueue.add(pid, "last")

    assert PhotoQueue.list(pid) == ["first", "last"]
  end

  test "producer and consumer work together" do
    {:ok, queue} = PhotoQueue.start_link()
    {:ok, processor} = PhotoProcessor.start_link()
    PhotoQueue.add(queue, "item-1")
    PhotoQueue.add(queue, "item-2")
    PhotoQueue.add(queue, "item-3")
    GenStage.sync_subscribe(processor, to: queue, max_demand: 1)
    PhotoQueue.add(queue, "item-4")
    PhotoQueue.add(queue, "item-5")
    PhotoQueue.add(queue, "item-6")
    Process.sleep(15000)
    assert PhotoQueue.list(queue) == []
  end
end
