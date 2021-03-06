defmodule ComplexKeypad do
  @doc """
   1
  2 3 4
5 6 7 8 9
  A B C
    D
  """
  @keypad %{
    1 => %{
      :d => 3
    },
    2 => %{
      :d => 6,
      :r => 3
    },
    3 => %{
      :l => 2,
      :r => 4,
    },
    4 => %{
      :l => 3,
      :d => 8
    },
    5 => %{
      :r => 6,
    },
    6 => %{
      :l => 5,
      :u => 2,
      :d => "A",
      :r => 7
    },
    7 => %{
      :l => 6,
      :u => 3,
      :d => "B",
      :r => 8
    },
    8 => %{
      :u => 4,
      :l => 7,
      :d => "C",
      :r => 9
    },
    9 => %{
      :l => 8,
    },
    "A" => %{
      :u => 6,
      :r => "B"
    },
    "B" => %{
      :u => 7,
      :l => "A",
      :d => "D",
      :r => "C"
    },
    "C" => %{
      :l => "B",
      :u => 8
    },
    "D" => %{
      :u => "B"
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
