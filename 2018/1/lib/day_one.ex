defmodule DayOne do
  def solve() do
    File.stream!("./input.txt")
    |> Enum.map(&clean_and_parse_input/1)
    |> Enum.reduce(0, &(&1 + &2))
  end

  def solve_part_two() do
    File.stream!("./input.txt")
    |> Enum.map(&clean_and_parse_input/1)
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new([0])}, fn num, {total, seen} ->
      freq = num + total

      case MapSet.member?(seen, freq) do
        true -> {:halt, freq}
        false -> {:cont, {freq, MapSet.put(seen, freq)}}
      end
    end)
  end

  defp clean_and_parse_input(num) do
    num
    |> String.replace("\n", "")
    |> String.to_integer()
  end
end
