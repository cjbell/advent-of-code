defmodule DaySevenTest do
  use ExUnit.Case
  doctest DaySeven

  @sample [
    {"A", "C"},
    {"F", "C"},
    {"B", "A"},
    {"D", "A"},
    {"E", "B"},
    {"E", "D"},
    {"E", "F"}
  ]

  describe "build_dependencies" do
    test "will generate a map" do
      expected = %{"A" => ["C"], "B" => ["A"], "C" => [], "D" => ["A"], "E" => ["F", "D", "B"], "F" => ["C"]}
      assert DaySeven.build_dependencies(@sample) == expected
    end
  end
end
