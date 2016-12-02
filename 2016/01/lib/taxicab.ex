defmodule Taxicab do
  @type direction :: {:l | :r, integer}
  @type heading :: :north | :south | :east | :west
  @type location :: {integer, integer}
  @type state :: {heading, location}

  @start_heading :north
  @start_location {0, 0}
  @input "./data/input.txt"

  def run() do
    File.read!(@input)
    |> run()
  end

  def run(input) do
    input
    |> process()
    |> walk()
    |> total_blocks()
  end

  @doc """
  Given a set of directions will return normalized tuples that
  represent them.
  """
  @spec process(String.t) :: [direction]
  def process(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&process_direction/1)
  end

  @spec walk([direction]) :: state
  def walk(directions) do
    {@start_heading, @start_location}
    |> walk(directions)
  end

  @spec walk(state, [direction]) :: state
  def walk(state, directions) do
    directions
    |> Enum.reduce(state, &walk_direction/2)
  end

  @spec total_blocks(state | location) :: integer
  def total_blocks({_, {_, _} = location}), do: total_blocks(location)
  def total_blocks({x, y}) do
    :erlang.abs(x) + :erlang.abs(y)
  end

  def walk_direction({direction, steps}, {current_heading, location}) do
    new_heading  = turn(current_heading, direction)
    new_location = take_steps(new_heading, steps, location)

    {new_heading, new_location}
  end

  def take_steps(:north, steps, {x, y}), do: {x, y + steps}
  def take_steps(:east, steps, {x, y}), do: {x + steps, y}
  def take_steps(:south, steps, {x, y}), do: {x, y - steps}
  def take_steps(:west, steps, {x, y}), do: {x - steps, y}

  def turn(:north, :l), do: :west
  def turn(:north, :r), do: :east
  def turn(:east, :l), do: :north
  def turn(:east, :r), do: :south
  def turn(:south, :l), do: :east
  def turn(:south, :r), do: :west
  def turn(:west, :l), do: :south
  def turn(:west, :r), do: :north

  defp process_direction("L" <> number_steps), do: {:l, String.to_integer(number_steps)}
  defp process_direction("R" <> number_steps), do: {:r, String.to_integer(number_steps)}
end
