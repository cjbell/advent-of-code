defmodule Keypad do
  @doc """
  1 2 3
  4 5 6
  7 8 9
  """
  @keypad %{
    1 => %{
      :r => 2,
      :d => 4
    },
    2 => %{
      :l => 1,
      :r => 3,
      :d => 5,
    },
    3 => %{
      :l => 2,
      :d => 6,
    },
    4 => %{
      :u => 1,
      :r => 5,
      :d => 7
    },
    5 => %{
      :l => 4,
      :u => 2,
      :d => 8,
      :r => 6
    },
    6 => %{
      :u => 3,
      :l => 5,
      :d => 9
    },
    7 => %{
      :u => 4,
      :r => 8,
    },
    8 => %{
      :l => 7,
      :r => 9,
      :u => 5
    },
    9 => %{
      :l => 8,
      :u => 6,
    }
  }
  @start_digit 5

  def run() do
    File.read!("./data/input.txt")
    |> process()
  end

  def process(input) do
    state = {@start_digit, []}

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(state, &process_line/2)
    |> format_keycode()
  end

  def format_keycode({_, code}), do: Enum.join(code, "")

  def process_line(commands, state) when is_binary(commands) do
    commands
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&parse_command/1)
    |> process_line(state)
  end
  def process_line([], {value, keycode}), do: {value, keycode ++ [value]}
  def process_line([command | tail], {value, result}) do
    value = move(command, value)
    process_line(tail, {value, result})
  end

  defp move(command, value) do
    @keypad
    |> Map.get(value)
    |> Map.get(command, value)
  end

  defp parse_command(command) do
    command |> String.downcase() |> String.to_atom()
  end
end
