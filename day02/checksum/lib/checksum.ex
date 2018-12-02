defmodule Checksum do

  def input do
    "assets/input.txt"
    |> File.read!()
    |> String.split(~r/\n/)
  end

  def is_valid_char(x) do
    String.match?(x, ~r/\w/)
  end

  def sanitized_input do
    input()
    |> Enum.filter(&is_valid_char/1)
  end

  def counts(id) do
    id
    |> String.graphemes
    |> Enum.reduce(%{}, fn(x, acc) ->
      Map.update(acc, x, 1, &(&1 + 1)) end)
  end

  def exactly(map, n) do
    map
    |> Enum.filter(fn(x) -> elem(x,1) == n end)
  end

  def exacts(counts) do
    {
      (if length(exactly(counts, 2)) >= 1, do: 1, else: 0),
      (if length(exactly(counts, 3)) >= 1, do: 1, else: 0),
    }
  end

  def tuple_add(x, acc) do
      {elem(acc,0) + elem(x,0), elem(acc,1)+ elem(x,1)}
  end

  def multi(exacts) do
    elem(exacts,0) * elem(exacts,1)
  end

  def get_masks(id) do
    id_list = String.graphemes(id)
    l = length(id_list)
    masks = for n <- 0..l-1, do: List.replace_at(id_list, n, "*")
  end

  def unmask(id) do
    id
    |> Enum.filter(fn(x) -> x != "*" end)
  end

  def result_1 do
    sanitized_input()
    |> Enum.map(&counts/1)
    |> Enum.map(&exacts/1)
    |> Enum.reduce(&tuple_add/2)
    |> multi
  end

  def result_2 do
    sanitized_input()
    |> Stream.flat_map(&get_masks/1)
    |> Enum.reduce_while(MapSet.new(), fn(x, acc) ->
      if MapSet.member?(acc, x), do: {:halt, x}, else: {:cont, MapSet.put(acc, x)}
    end)
    |> Checksum.unmask
    |> Enum.join
  end

end
