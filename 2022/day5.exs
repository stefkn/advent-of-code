# Read the stack input into memory
# We've removed the redundant index row at the end (row 9) and split the input into two files for easier parsing
{:ok, filecontents} = File.read("input/day5_1.txt")

# Split input into list of strings on newline "[Q] [J] [D] [M]     [Z] [C] [M] [F]"
splitcontents = filecontents |> String.split("\n", trim: true)

# Split strings into lists of smaller strings ["[Q]", "[J]", "[D]", "[M]", "", "", "", "", "[Z]", "[C]", "[M]", "[F]"],
splitcontents = Enum.map(
  splitcontents, fn x -> String.split(x, " ", trim: false)
end)

# replace the series of empty strings with correct number of spaces to retain sequence info -- four consecutive ""s equals one empty space in the stack
defmodule Recursion do
  # Recursive step
  def iterate_through_stackinput(tupleslist, n, result) when n > 0 do
    # Get the nth element
    current = length(tupleslist) - n
    {:ok, elem1} = Enum.fetch(tupleslist, current)

    # if the element is the empty string, and there's at least 3 more elements in front to check, check if they are all also the empty string -- if they are, skip forwards by 4 and replace by a single ""
    if length(tupleslist) > current + 3 do
      {:ok, elem2} = Enum.fetch(tupleslist, current + 1)
      {:ok, elem3} = Enum.fetch(tupleslist, current + 2)
      {:ok, elem4} = Enum.fetch(tupleslist, current + 3)
      # IO.inspect elem2
      # IO.inspect elem3
      # IO.inspect elem4

      # replacing all sequences of four spaces turned out to be unnecessary -- we're dealing with stacks so emptiness at the top can be totally disregarded with no loss of information. oh well, still gonna leave it here.
      if ["", "", "", ""] === [elem1, elem2, elem3, elem4] do
        result = result ++ [""]

        if length(tupleslist) > current + 3 do
          iterate_through_stackinput(tupleslist, n - 4, result)
        else
          iterate_through_stackinput(tupleslist, n - 1, result)
        end
      else
        result = result ++ [elem1]
        iterate_through_stackinput(tupleslist, n - 1, result)
      end
    else
      result = result ++ [elem1]
      iterate_through_stackinput(tupleslist, n - 1, result)
    end
  end

  # base case
  def iterate_through_stackinput(tupleslist, 0, result) do
    {:ok, result}
  end
end

splitcontents = Enum.map(
  splitcontents,
  fn x ->
    elem(
      Recursion.iterate_through_stackinput(x, length(x), []),
    1)
end)

# Now splitcontents looks like:
# [
#   ["[T]", "", "[Q]", "", "", "", "[S]", "", ""],
#   ["[R]", "", "[M]", "", "", "", "[L]", "[V]", "[G]"],
#   ["[D]", "[V]", "[V]", "", "", "", "[Q]", "[N]", "[C]"],
#   ["[H]", "[T]", "[S]", "[C]", "", "", "[V]", "[D]", "[Z]"],
#   ["[Q]", "[J]", "[D]", "[M]", "", "[Z]", "[C]", "[M]", "[F]"],
#   ["[N]", "[B]", "[H]", "[N]", "[B]", "[W]", "[N]", "[J]", "[M]"],
#   ["[P]", "[G]", "[R]", "[Z]", "[Z]", "[C]", "[Z]", "[G]", "[P]"],
#   ["[B]", "[W]", "[N]", "[P]", "[D]", "[V]", "[G]", "[L]", "[T]"]
# ]
# We still need to "transpose" this as each list doesn't yet repesent each stack

# Thanks to https://elixirforum.com/t/transpose-a-list-of-lists-using-list-comprehension/17638/2
defmodule Transp do
  def transpose([[] | _]), do: []
  def transpose(m) do
    [Enum.map(m, &hd/1) | transpose(Enum.map(m, &tl/1))]
  end
end

stacks = Transp.transpose(splitcontents)

# Now things looks like, stacks are represented accurately:
# [
#   ["[T]", "[R]", "[D]", "[H]", "[Q]", "[N]", "[P]", "[B]"],
#   ["", "", "[V]", "[T]", "[J]", "[B]", "[G]", "[W]"],
#   ["[Q]", "[M]", "[V]", "[S]", "[D]", "[H]", "[R]", "[N]"],
#   ["", "", "", "[C]", "[M]", "[N]", "[Z]", "[P]"],
#   ["", "", "", "", "", "[B]", "[Z]", "[D]"],
#   ["", "", "", "", "[Z]", "[W]", "[C]", "[V]"],
#   ["[S]", "[L]", "[Q]", "[V]", "[C]", "[N]", "[Z]", "[G]"],
#   ["", "[V]", "[N]", "[D]", "[M]", "[J]", "[G]", "[L]"],
#   ["", "[G]", "[C]", "[Z]", "[F]", "[M]", "[P]", "[T]"]
# ]
# Nice!

# Remove all empty strings -- see comment above lol
stacks = Enum.map(
  stacks,
  fn x -> Enum.filter(
    x, fn x -> x !== "" end
  ) end
)

# Now let's parse the instructions

# Read the stack input into memory
{:ok, filecontents2} = File.read("input/day5_2.txt")

# Split input into list of strings on newline "move 5 from 4 to 9"
splitcontents2 = filecontents2 |> String.split("\n", trim: true)

# lets parse strings into tuples
splitcontents2 = Enum.map(
  splitcontents2, fn x -> String.split(x, " ", trim: true)
end)

# lets parse tuples into maps %{from: "4", num: "5", to: "9"}
instructions = Enum.map(
  splitcontents2, fn [move, movnum, from, fromnum, to, tonum] ->
    %{num: movnum, from: fromnum, to: tonum}
end)

# Everything is parsed! Now lets play the instructions on our stacks
defmodule Recursion2 do
  # Recursive step
  def apply_instructions(inslist, n, result, stacks) when n > 0 do
    # Get the nth element
    current = length(inslist) - n
    {:ok, i} = Enum.fetch(inslist, current)

    # IO.inspect i
    # IO.inspect result

    fromstackindex = elem(Integer.parse(i.from), 0) - 1
    tostackindex = elem(Integer.parse(i.to), 0) - 1

    {:ok, fromstack} = Enum.fetch(result, fromstackindex)
    {:ok, tostack} = Enum.fetch(result, tostackindex)

    # IO.inspect fromstack
    # IO.inspect tostack

    {newfromstack, newtostack} = Enum.reduce(
      0..elem(Integer.parse(i.num), 0)-1,
      {fromstack, tostack},
      fn(x, acc) ->
        if elem(acc, 0) === [] do
          {
            [],
            elem(acc, 1),
          }
        else
          {
            tl(elem(acc, 0)),
            [hd(elem(acc, 0)) | elem(acc, 1)],
          }
        end
      end
    )

    # IO.inspect newfromstack
    # IO.inspect newtostack

    result = List.replace_at(result, fromstackindex, newfromstack)
    result = List.replace_at(result, tostackindex, newtostack)

    # IO.inspect result

    apply_instructions(inslist, n - 1, result, stacks)
  end

  # base case
  def apply_instructions(inslist, 0, result, stacks) do
    {:ok, result}
  end
end

{:ok, res} = Recursion2.apply_instructions(instructions, length(instructions),
stacks, stacks)

IO.inspect res

# Part 2

{newfromstack, newtostack} = {
  Enum.take(fromstack, - length(fromstack) + elem(Integer.parse(i.num), 0)),
  Enum.take(fromstack, elem(Integer.parse(i.num), 0)) ++
  tostack
}
