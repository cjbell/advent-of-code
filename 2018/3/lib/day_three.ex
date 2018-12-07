defmodule DayThree do
  @claim_regex ~r/#(?<id>[^\s]+)\s@\s(?<x>\d+),(?<y>\d+):\s(?<w>\d+)x(?<h>\d+)/

  def solve_part_one() do
    File.stream!("./input.txt") |> solve_part_one()
  end
  def solve_part_one(claims) do
    claims
    |> produce_matrix()
    |> Enum.reduce(0, &sum_intersecting_values/2)
  end

  def solve_part_two() do
    File.stream!("./input.txt") |> solve_part_two()
  end
  def solve_part_two(claims) do
    matrix = claims |> produce_matrix()

    claims
    |> Enum.map(&transform_claims/1)
    |> Enum.sort_by(&sort_claims_by_x/1)
    |> Enum.find(&claim_does_not_intersect?(matrix, &1))
    |> elem(0)
  end

  def produce_matrix(input) do
    sorted_claims =
      input
      |> Enum.map(&transform_claims/1)
      |> Enum.sort_by(&sort_claims_by_x/1)

    {_, {_, _}, {x2, y2}} = Enum.max_by(sorted_claims, fn
      {_, _, {x2, y2}} when x2 > y2 -> x2
      {_, _, {_, y2}} -> y2
    end)

    biggest_side = Kernel.max(x2, y2) + 1
    matrix = build_matrix(biggest_side, biggest_side)

    sorted_claims
    |> Enum.reduce(matrix, &layout_claim_in_matrix/2)
  end

  defp transform_claims(claim) do
    [id, x1, y1, w, h] =
      Regex.run(@claim_regex, claim)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)

    {id, {x1, y1}, {x1 + w, y1 + h}}
  end

  defp sort_claims_by_x({_, {x, _}, {_, _}}), do: x

  defp layout_claim_in_matrix({_, {x1, y1}, {x2, y2}}, matrix) do
    x_range = x1..x2 - 1
    y_range = y1..y2 - 1

    x_range |> Enum.reduce(matrix, fn x, matrix ->
      y_range |> Enum.reduce(matrix, fn y, matrix ->
        increment_elem(matrix, y, x)
      end)
    end)
  end

  defp sum_intersecting_values(row, acc) do
    row |> Enum.reduce(acc, fn
      col, acc when col >= 2 -> acc + 1 # only take two or more intersections
      _, acc -> acc
    end)
  end

  defp claim_does_not_intersect?(matrix, {_, {x1, y1}, {x2, y2}}) do
    x_range = x1..x2 - 1
    y_range = y1..y2 - 1

    x_range |> Enum.all?(fn x ->
      y_range |> Enum.all?(fn y ->
        element(matrix, y, x) == 1
      end)
    end)
  end

  # Matrix helper functions

  def build_matrix(rows, cols), do: for _r <- 1..rows, do: build_matrix_row(cols)
  defp build_matrix_row(0), do: []
  defp build_matrix_row(n), do: [0] ++ build_matrix_row(n - 1)

  defp element(matrix, row, col), do: Enum.at(matrix, row) |> Enum.at(col)

  defp increment_elem(matrix, row, col) do
    row_vals = Enum.at(matrix, row)
    new_row = List.update_at(row_vals, col, &(&1 + 1))
    List.replace_at(matrix, row, new_row)
  end
end
