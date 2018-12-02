defmodule DayTwo do
  def solve() do
    {two, three} =
      File.stream!("./input.txt")
      |> Enum.map(& String.replace(&1, "\n", ""))
      |> Enum.reduce({0, 0}, &count_letters/2)

    two * three
  end

  def solve_part_two() do
    all_codes =
      File.stream!("./input.txt")
      |> Enum.map(& String.replace(&1, "\n", ""))

    all_codes
    |> Enum.reduce_while({nil, nil}, &find_closely_matching_code(all_codes, &1, &2))
    |> common_characters()
  end

  # Part one
  defp count_letters(id_code, {two, three}) do
    id_code_letters = id_code |> String.graphemes()

    id_code_letters
    |> Enum.uniq()
    |> Enum.reduce([], fn letter, items_with_count ->
      occurrences = Enum.count(id_code_letters, & &1 == letter)
      [{letter, occurrences} | items_with_count]
    end)
    |> Enum.uniq_by(& elem(&1, 1)) # only get the first occurrence of each
    |> Enum.reduce({two, three}, fn
      {_, 2}, {two, three} -> {two + 1, three}
      {_, 3}, {two, three} -> {two, three + 1}
      _, count -> count
    end)
  end

  # Part two
  defp find_closely_matching_code(codes, id_code, {first, second}) do
    codes
    |> Enum.find(&has_exactly_one_differing_char?(id_code, &1))
    |> case do
      nil -> {:cont, {first, second}}
      other_code -> {:halt, {id_code, other_code}}
    end
  end

  defp build_matches(code_one, code_two) do
    code_two_list = code_two |> String.graphemes()

    code_one
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(&characters_match?(&1, code_two_list))
  end

  defp has_exactly_one_differing_char?(code_one, code_two) do
    build_matches(code_one, code_two)
    |> Enum.filter(& !elem(&1, 1))
    |> Enum.count()
    |> case do
      1 -> true
      _ -> false
    end
  end

  defp common_characters({code_one, code_two}) do
    build_matches(code_one, code_two)
    |> Enum.filter(& elem(&1, 1))
    |> Enum.map(& elem(&1, 0))
    |> Enum.join("")
  end

  defp characters_match?({letter, index}, code_two_list) do
    Enum.at(code_two_list, index)
    |> case do
      ^letter -> {letter, true}
      _ -> {letter, false}
    end
  end
end
