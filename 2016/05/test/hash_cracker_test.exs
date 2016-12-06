defmodule HashCrackerTest do
  use ExUnit.Case
  doctest HashCracker

  describe "#solve/1" do
    test "will solve for abc" do
      input = "abc"
      expected = "18f47a30"

      assert HashCracker.solve(input) == expected
    end
  end
end
