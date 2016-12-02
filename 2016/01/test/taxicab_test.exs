defmodule TaxicabTest do
  use ExUnit.Case
  doctest Taxicab

  describe "#run/1" do
    test "R2, L3" do
      input = "R2, L3"
      expected = 5
      assert Taxicab.run(input) == expected
    end

    test "R2, R2, R2" do
      input = "R2, R2, R2"
      expected = 2
      assert Taxicab.run(input) == expected
    end

    test "R5, L5, R5, R3" do
      input = "R5, L5, R5, R3"
      expected = 12
      assert Taxicab.run(input) == expected
    end
  end

  describe "#process/1" do
    test "will process a single value" do
      input = "L1"
      expected = [{:l, 1}]
      assert Taxicab.process(input) == expected
    end

    test "will process multiple values" do
      input = "L1, R2, R3"
      expected = [{:l, 1}, {:r, 2}, {:r, 3}]
      assert Taxicab.process(input) == expected
    end
  end

  describe "#walk/1" do
    test "will calculate the correct final state" do
      input = [{:r, 2}, {:l, 3}]
      expected = {:north, {2, 3}}
      assert Taxicab.walk(input) == expected
    end
  end

  describe "#total_blocks/1" do
    test "will calculate the correct total blocks" do
      input = {2, 3}
      expected = 5
      assert Taxicab.total_blocks(input) == expected
    end
  end
end
