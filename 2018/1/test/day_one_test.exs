defmodule DayOneTest do
  use ExUnit.Case
  doctest DayOne

  test "greets the world" do
    assert DayOne.hello() == :world
  end
end
