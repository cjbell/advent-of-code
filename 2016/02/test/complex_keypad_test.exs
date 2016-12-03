defmodule ComplexKeypadTest do
  use ExUnit.Case

  describe "#process/1" do
    test "dummy code will work" do
      command  = "ULL\nRRDDD\nLURDL\nUUUUD"
      expected = "5DB3"

      assert ComplexKeypad.process(command) == expected
    end
  end
end
