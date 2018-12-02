defmodule DayTwoTest do
  use ExUnit.Case
  doctest DayTwo

  test "greets the world" do
    assert DayTwo.hello() == :world
  end
end
