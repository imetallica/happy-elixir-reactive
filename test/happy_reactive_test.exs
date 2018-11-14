defmodule HappyReactiveTest do
  use ExUnit.Case
  doctest HappyReactive

  test "greets the world" do
    assert HappyReactive.hello() == :world
  end
end
