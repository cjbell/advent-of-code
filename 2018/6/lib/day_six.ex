defmodule DaySix do
  def solve_part_one() do
    coords() |> largest_area()
  end

  def largest_area(coords) do
    coords_with_index = Enum.with_index(coords)
    inner_ids = inner_ids(coords_with_index)

    coords
    |> nearest_points(coords_with_index)
    |> Enum.filter(&MapSet.member?(inner_ids, &1))
    |> Enum.group_by(& &1) # group by the returned index (id)
    |> Enum.map(fn {_, vals} -> length(vals) end)
    |> Enum.max()
  end

  defp inner_ids(coords) do
    bounds = grid_bounds(coords)

    coords
    |> Enum.reject(&coords_in_bounds(&1, bounds))
    |> Enum.map(&elem(&1, 1)) # take the ids
    |> MapSet.new()
    |> MapSet.put(-1) # tie id
  end

  defp nearest_points(coords, coords_with_index) do
    coords
    |> positions_in_grid()
    |> Enum.map(&closest_coordinates(&1, coords_with_index))
  end

  defp positions_in_grid(coords) do
    {y1, x2, y2, x1} = grid_bounds(coords)
    for x <- x1..x2, y <- y1..y2, do: {x, y}
  end

  defp grid_bounds(coords) do
    {{x1, _}, {x2, _}} = Enum.min_max_by(coords, &elem(&1, 0), &elem(&1, 0))
    {{_, y1}, {_, y2}} = Enum.min_max_by(coords, &elem(&1, 1), &elem(&1, 1))

    {y1, x2, y2, x1} # t, r, b, l
  end

  defp closest_coordinates(coord, coords_with_index) do
    coords_with_index
    |> Enum.map(fn {coord2, id} -> {id, manhattan_distance(coord, coord2)} end)
    |> Enum.sort_by(&elem(&1, 1))
    |> closest_id()
  end

  defp closest_id([{_, dist}, {_, dist} | _]), do: -1 # if same dist, drop
  defp closest_id([{id, _} | _]), do: id

  defp coords_in_bounds({{x, y}, _}, {top, right, bottom, left})
    when x in [left, right] or y in [top, bottom], do: true
  defp coords_in_bounds(_, _), do: false

  defp manhattan_distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  defp coords() do
    File.stream!("./input.txt")
    |> Enum.map(&parse_coord/1)
  end

  defp parse_coord(line) do
    [x, y] = line |> String.replace("\n", "") |> String.split(", ") |> Enum.map(&String.to_integer/1)
    {x, y}
  end
end
