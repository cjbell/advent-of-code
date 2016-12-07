defmodule RepetitionCode do

  def solve() do
    File.stream!("./data/input.txt")
    |> Enum.map(&to_graphemes/1)
    |> Enum.reduce(%{}, &build_frequency_line/2)
    |> Map.values()
    |> Enum.map(&highest_frequency_chars/1)
    |> Enum.join("")
  end

  def solve_two() do
    File.stream!("./data/input.txt")
    |> Enum.map(&to_graphemes/1)
    |> Enum.reduce(%{}, &build_frequency_line/2)
    |> Map.values()
    |> Enum.map(&lowest_frequency_chars/1)
    |> Enum.join("")
  end

  def to_graphemes(input) do
    input
    |> String.trim()
    |> String.graphemes()
  end

  def build_frequency_line(line, acc) do
    line
    |> Enum.with_index()
    |> Enum.reduce(acc, &build_frequency/2)
  end

  def build_frequency({char, index}, acc) do
    freq_map =
      acc
      |> Map.get(index, %{})
      |> Map.put_new(char, 0)
      |> Map.update!(char, &(&1 + 1))

    Map.put(acc, index, freq_map)
  end

  def highest_frequency_chars(freq_map) do
    freq_map
    |> Enum.max_by(fn {_, v} -> v end)
    |> elem(0)
  end

  def lowest_frequency_chars(freq_map) do
    freq_map
    |> Enum.min_by(fn {_, v} -> v end)
    |> elem(0)
  end
end
