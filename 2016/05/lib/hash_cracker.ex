defmodule HashCracker do
  @valid_pos ~w(0 1 2 3 4 5 6 7)
  @empty_list ["", "", "", "", "", "", "", ""]

  def solve(hash) do
    md5_stream(hash)
    |> Stream.filter(&interesting_hash?/1)
    |> Enum.take(8)
    |> Enum.map(&String.at(&1, 5))
    |> Enum.join("")
    |> String.downcase()
  end

  def solve_complex(hash) do
    md5_stream(hash)
    |> Stream.filter(&interesting_hash?/1)
    |> Enum.reduce_while(%{}, &build_password/2)
    |> Map.values()
    |> Enum.join("")
    |> String.downcase()
  end

  def md5_stream(hash) do
    Stream.iterate(0, &(&1+1))
    |> Stream.map(&encode(hash, &1))
  end

  def build_password(_, password) when map_size(password) == 8, do: {:halt, password}
  def build_password("00000" <> <<pos :: bytes-size(1), char :: bytes-size(1)>> <> _rest, password) when pos in @valid_pos do
    {:cont, Map.put_new(password, pos, char)}
  end
  def build_password(_, password), do: {:cont, password}

  def interesting_hash?("00000" <> _rest), do: true
  def interesting_hash?(_), do: false

  def encode(hash, n) do
    hash <> Integer.to_string(n)
    |> :erlang.md5()
    |> Base.encode16()
  end
end
