defmodule Triangles do

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
  end

  def valid_triangle?([a, b, c] = sides) do
    max = Enum.max(sides)
    max < a + b + c - max
  end

  def process_line(line) do
    line
    |> String.split(~r/\s/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
