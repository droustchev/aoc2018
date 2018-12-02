defmodule Frequency do

  def input do
    "assets/input.txt"
    |> File.read!()
    |> String.split(~r/\n/)
  end

  def is_valid_int(x) do
    String.match?(x, ~r/\d/)
  end

  def sanitized_input do
    input()
    |> Enum.filter(&is_valid_int/1)
    |> Enum.map(&String.to_integer/1)
  end

  def result_1 do
    sanitized_input()
    |> Enum.sum()
  end

  def result_2 do
    sanitized_input()
    |> Stream.cycle()
    |> Enum.reduce_while({MapSet.new(), 0}, fn (x, acc) ->
      seen = elem(acc, 0)
      prev = elem(acc, 1)
      freq = prev + x
      if MapSet.member?(seen, freq), do: {:halt, freq}, else: {:cont, {MapSet.put(seen, freq), freq}}
    end)
  end

end
