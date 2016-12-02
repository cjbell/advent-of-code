defmodule TaxicabWithHistory do
  import Taxicab, except: [walk_direction: 2, run: 0, run: 1, total_blocks: 1]

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
    |> walk_with_history()
    |> total_blocks()
  end

  def walk_with_history(directions) do
    {@start_heading, @start_location, []}
    |> walk_with_history(directions)
  end

  def walk_with_history(state, directions) do
    directions
    |> Enum.reduce_while(state, &walk_direction/2)
  end

  def total_blocks({_, location, _}), do: Taxicab.total_blocks(location)

  def walk_direction({direction, 0}, {current_heading, location, visited}) do
    # Finally actually make the turn for the new state once we've finished calculating 
    new_heading = turn(current_heading, direction)
    {:cont, {new_heading, location, visited}}
  end
  def walk_direction({direction, steps}, {current_heading, location, visited}) do
    new_heading  = turn(current_heading, direction)
    new_location = take_steps(new_heading, 1, location)

    case already_visited?(visited, new_location) do
      true  ->
        {:halt, {new_heading, new_location, visited}}
      false ->
        # Recurse over every step
        visited   = visited ++ [new_location]
        new_state = {current_heading, new_location, visited}
        walk_direction({direction, steps - 1}, new_state)
    end
  end

  def already_visited?(visited, location) do
    Enum.member?(visited, location)
  end
end
