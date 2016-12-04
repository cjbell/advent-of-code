defmodule RoomNamesTest do
  use ExUnit.Case
  doctest RoomNames

  describe "#decode/1" do
    test "will decode names, sector_id and checksum" do
      input = "aaaaa-bbb-z-y-x-123[abxyz]"
      expected = {["aaaaa", "bbb", "z", "y", "x"], 123, "abxyz"}
      assert RoomNames.decode(input) == expected
    end
  end

  describe "#valid?" do
    test "will return true for valid conditions" do
      input = {["aaaaa", "bbb", "z", "y", "x"], 123, "abxyz"}
      assert RoomNames.valid?(input)
    end

    test "will return true for other valid conditions" do
      input = {["a", "b", "c", "d", "e", "f", "g", "h"], 987, "abcde"}
      assert RoomNames.valid?(input)
    end

    test "moar valid" do
      input = {["not", "a", "real", "room"], 404, "oarel"}
      assert RoomNames.valid?(input)
    end

    test "will return false for an invalid condition" do
      input = {["totally", "real", "room"], 200, "decoy"}
      refute RoomNames.valid?(input)
    end
  end

  describe "#decrypt_name/1" do
    test "will work" do
      input = {["qzmt", "zixmtkozy", "ivhz"], 343, "blah"}
      expected = {["very", "encrypted", "name"], 343, "blah"}
      assert RoomNames.decrypt(input) == expected
    end
  end
end
