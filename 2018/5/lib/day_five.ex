defmodule DayFive do
  def solve() do
    input() |> react_polymer() |> length()
  end

  def solve_part_two() do
    polymer = input()

    polymer
    |> unique_chars()
    |> Enum.reduce(%{}, &react_polymer_without_char(&1, polymer, &2))
    |> Enum.min_by(fn {_, length} -> length end)
  end

  defp react_polymer_without_char(char, polymer, acc) do
    polymer_length =
      polymer
      |> Enum.reject(fn
        a when a == char -> true
        a -> pair_react?(a, char)
      end)
      |> react_polymer()
      |> length()

    Map.put(acc, char, polymer_length)
  end

  defp unique_chars(polymer) do
    polymer
    |> to_string()
    |> String.downcase()
    |> String.to_charlist()
    |> Enum.uniq()
  end

  defp react_polymer([]), do: []
  defp react_polymer([a | rest]) do
    case react_polymer(rest) do
      [] -> [a]
      [b | rest] -> process_pair(a, b) ++ rest
    end
  end

  defp process_pair(a, b) do
    case pair_react?(a, b) do
      true -> []
      false -> [a, b] # keep 'em
    end
  end

  defp input() do
    File.read!("./input.txt")
    |> String.to_charlist()
  end

  defp pair_react?(a, b) when abs(a - b) == 32, do: true
  defp pair_react?(_, _), do: false
end
