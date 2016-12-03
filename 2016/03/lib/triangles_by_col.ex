defmodule TrianglesByCol do
  import Triangles, only: [valid_triangle?: 1, process_line: 1]

  def run() do
    File.read!("./data/input.txt")
    |> process()
    |> Enum.filter(&valid_triangle?/1)
    |> Enum.count()
  end

  def process(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&process_line/1)
    |> resort_lines()
  end

  def resort_lines([]), do: []
  def resort_lines([[a1, b1, c1], [a2, b2, c2], [a3, b3, c3] | rest]) do
    [
      [a1, a2, a3],
      [b1, b2, b3],
      [c1, c2, c3]
      | resort_lines(rest)
    ]
  end
end
