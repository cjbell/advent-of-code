defmodule RoomNames do

  def run() do
    File.read!("./data/input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&decode/1)
    |> Enum.filter(&valid?/1)
    |> Enum.reduce(0, &sum_sectors/2)
  end

  def decode(input) do
    input
    |> String.trim()
    |> extract_parts()
    |> extract_checksum()
  end

  def valid?({names, _, checksum}) do
    names
    |> Enum.reduce(%{}, &count_occurences/2)
    |> Enum.sort_by(&map_values/1, &sort/2)
    |> Enum.take(5)
    |> List.foldl("", fn ({l, _}, v) -> v <> l end)
    |> Kernel.==(checksum)
  end

  defp extract_parts(input) do
    input
    |> String.split("-")
    |> Enum.split(-1)
  end

  defp extract_checksum({names, [<<sector_id :: bytes-size(3)>> <> "[" <> <<checksum :: bytes-size(5)>> <> "]"]}) do
    {names, String.to_integer(sector_id), checksum}
  end

  defp count_occurences(name, letters) do
    name
    |> String.graphemes()
    |> Enum.reduce(letters, &count_occurence/2)
  end

  defp count_occurence(letter, letters) do
    Map.get(letters, letter)
    |> case do
      nil   -> Map.put(letters, letter, 1)
      count -> Map.put(letters, letter, count + 1)
    end
  end

  defp sort([c1 | _ ] = one, [c2 | _] = two) 
    when length(one) == length(two), do: c1 < c2 
  defp sort(one, two), do: length(one) > length(two)

  defp map_values({k, v}) do
    for _ <- 0..v, do: k
  end

  defp sum_sectors({_, sector_id, _}, acc), do: acc + sector_id
end
