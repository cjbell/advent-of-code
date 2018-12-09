defmodule DaySeven do
  def solve() do
    parse_input() |> part_one()
  end

  defp part_one(input) do
    dependencies = build_dependencies(input)
    first_step = next_step(dependencies) |> hd()

    perform_step(dependencies, first_step)
    |> Enum.reverse()
    |> List.to_string()
  end

  defp perform_step(deps, letter, performed \\ []) do
    deps = deps |> clear_step(letter) # Clear anything that depends on this step
    performed = [letter | performed] # keep track of everything we've seen so far

    case next_step(deps) do
      [] -> performed
      [x | _] -> perform_step(deps, x, performed)
    end
  end

  defp clear_step(deps, letter) do
    deps
    |> Map.delete(letter)
    |> Enum.map(fn {x, depends_on} ->
      {x, Enum.reject(depends_on, & &1 == letter)}
    end)
    |> Enum.into(%{})
  end

  defp all_steps(input) do
    input
    |> Enum.map(&Tuple.to_list/1)
    |> List.flatten()
    |> Enum.uniq()
  end

  def build_dependencies(input) do
    initial = input |> all_steps() |> Enum.reduce(%{}, & Map.put(&2, &1, []))

    input
    |> Enum.reduce(initial, fn {x, y}, acc ->
      Map.update(acc, x, [y], &[y | &1])
    end)
  end

  defp next_step(deps) do
    deps
    |> Enum.filter(fn {_, deps} -> length(deps) == 0 end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sort()
  end

  defp parse_input() do
    File.stream!("./input.txt")
    |> Enum.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(
    <<"Step ", x::binary-1, " must be finished before step ", y::binary-1, " can begin.">>
  ), do: {y, x}
end
