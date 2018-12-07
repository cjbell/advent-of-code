defmodule DayThreeTest do
  use ExUnit.Case

  @input [
    "#1 @ 1,3: 4x4",
    "#2 @ 3,1: 4x4",
    "#3 @ 5,5: 2x2",
  ]

  test "will produce a simple matrix test case" do
    expected =
      [[0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 1, 1, 1, 1, 0, 0, 0],
      [0, 1, 1, 1, 1, 0, 0, 0],
      [0, 1, 1, 1, 1, 0, 0, 0],
      [0, 1, 1, 1, 1, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0]]

    assert DayThree.produce_matrix(["#1 @ 1,3: 4x4",]) == expected
  end

  test "will produce the expected matrix" do
    expected =
      [[0, 0, 0, 0, 0, 0, 0, 0],
       [0, 0, 0, 1, 1, 1, 1, 0],
       [0, 0, 0, 1, 1, 1, 1, 0],
       [0, 1, 1, 2, 2, 1, 1, 0],
       [0, 1, 1, 2, 2, 1, 1, 0],
       [0, 1, 1, 1, 1, 1, 1, 0],
       [0, 1, 1, 1, 1, 1, 1, 0],
       [0, 0, 0, 0, 0, 0, 0, 0]]

    assert DayThree.produce_matrix(@input) == expected
  end

  test "will produce the expected result" do
    assert DayThree.solve_part_one(@input) == 4
  end

  test "will find the non intersecting claim" do
    assert DayThree.solve_part_two(@input) == 3
  end
end
