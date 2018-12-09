defmodule DaySixTest do
  use ExUnit.Case
  doctest DaySix

  test "largest_area works as expected" do
    test_data = [
      {1, 1},
      {1, 6},
      {8, 3},
      {3, 4},
      {5, 5},
      {8, 9}
    ]

    assert DaySix.largest_area(test_data) == 17
  end
end
