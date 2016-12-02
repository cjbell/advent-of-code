defmodule TaxicabWithHistoryTest do
  use ExUnit.Case

  describe "#run/1" do
    test "R8, R4, R4, R8" do
      input = "R8, R4, R4, R8"
      expected = 4
      assert TaxicabWithHistory.run(input) == expected
    end
  end
end
