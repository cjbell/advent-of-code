defmodule KeypadTest do
  use ExUnit.Case
  doctest Keypad

  describe "#process/1" do
    test "dummy code will work" do
      command  = "ULL\nRRDDD\nLURDL\nUUUUD"
      expected = "1985"

      assert Keypad.process(command) == expected
    end
  end
end
