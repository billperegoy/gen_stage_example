defmodule GenStageExampleTest do
  use ExUnit.Case
  doctest GenStageExample

  test "greets the world" do
    assert GenStageExample.hello() == :world
  end
end
