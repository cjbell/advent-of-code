defmodule DayFour do
  @cmd_regex ~r/\[\d{4}-\d\d-\d\d \d\d:(?<minute>\d\d)\] (?<command>.*)/

  defmodule Guard do
    defstruct [:id, {:cycles, []}]
  end

  def generate_guards() do
    File.stream!("./input.txt")
    |> Enum.sort()
    |> Enum.map(&parse_line/1)
    |> Enum.reduce({%{}, nil}, &accumulate_shifts/2)
    |> elem(0)
    |> Map.values()
    |> Enum.reject(&Enum.empty?(&1.cycles))
  end

  def solve_part_one() do
    %Guard{id: id} = guard =
      generate_guards()
      |> Enum.max_by(&sum_minutes_sleeping/1)

    {min, _} = most_asleep_minute(guard)
    id * min
  end

  def solve_part_two() do
    {id, {min, _}} =
      generate_guards()
      |> Enum.map(fn %Guard{id: id} = guard -> {id, most_asleep_minute(guard)} end)
      |> Enum.max_by(fn {_, {_, times}} -> times end)

    id * min
  end

  defp parse_line(line) do
    %{"minute" => min, "command" => command} = Regex.named_captures(@cmd_regex, line)

    case parse_command(command) do
      {id, command} -> {id, command, String.to_integer(min)}
      command -> {command, String.to_integer(min)}
    end
  end

  defp accumulate_shifts({id, :begin_shift, _}, {guards, _}),
    do: {Map.put_new(guards, id, new_guard(id)), id}
  defp accumulate_shifts({:fall_asleep, min}, {guards, id}),
    do: {Map.update!(guards, id, &sleep(&1, min)), id}
  defp accumulate_shifts({:wake_up, min}, {guards, id}),
    do: {Map.update!(guards, id, &wake_up(&1, min)), id}

  defp new_guard(id), do: %Guard{id: id}

  defp sleep(%Guard{cycles: sleeps} = guard, min),
    do: %{guard | cycles: [{min, nil} | sleeps]}

  defp wake_up(%Guard{cycles: [{from, nil} | sleeps]} = guard, min),
    do: %{guard | cycles: [from..min - 1 | sleeps]}

  defp sum_minutes_sleeping(%Guard{cycles: cycles}),
    do: cycles |> Stream.concat() |> Enum.count()

  defp most_asleep_minute(%Guard{cycles: cycles}) do
    # given a list of ranges, build a frequency map like %{0 => 1, 1 => 2, 3 => 1}
    cycles
    |> Stream.concat()
    |> Enum.reduce(%{}, fn minute, acc ->
      Map.update(acc, minute, 1, &(&1 + 1))
    end)
    |> Enum.max_by(&elem(&1, 1))
  end

  defp parse_command("wakes up"), do: :wake_up
  defp parse_command("falls asleep"), do: :fall_asleep
  defp parse_command("Guard #" <> guard_id), do: parse_guard_id(guard_id)

  defp parse_guard_id(guard_id) do
    {id, _} = Integer.parse(guard_id)
    {id, :begin_shift}
  end
end
