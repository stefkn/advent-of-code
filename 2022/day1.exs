IO.puts "hello world\n"

# Read the file into memory
{:ok, filecontents} = File.read("input/day1.txt")

IO.inspect filecontents

# Split the ByteString on newline
splitcontents = filecontents |> String.split("\n", trim: false)

IO.inspect splitcontents

# Parse (cast) bytestrings into tuples with ints inside
tupleslist = Enum.map(splitcontents, fn x -> Integer.parse(x) end)

IO.inspect tupleslist

# Grab just the ints from inside each of the tuples
intlist = Enum.map(tupleslist, fn x -> if is_tuple(x), do: elem(x, 0), else: :none end)

IO.inspect intlist
IO.inspect length(intlist)

# Define a recursive function for going through the intlist
defmodule Recursion do
  # Recursive step
  def iterate_through_intlist(intlist, n, result) when n > 0 do
    # Get the nth element
    elem = Enum.fetch(intlist, length(intlist) - n)

    result = case elem do
      {:ok, :none} ->
        # We have reached the end of a sub-list, add a new accumulator on the result
        IO.inspect "===none==="

        [ 0 ] ++ result
      {:ok, x} ->
        # value, add it to the current accumulator
        IO.inspect x

        [ hd(result) + x ]  ++ tl(result)
    end

    IO.inspect result
    IO.puts "\n"

    iterate_through_intlist(intlist, n - 1, result)
  end

  # base case
  def iterate_through_intlist(intlist, 0, result) do
    {:ok, result}
  end
end

{:ok, res} = Recursion.iterate_through_intlist(intlist, length(intlist), [0])

largest = Enum.max(res)
IO.puts "1st largest integer: #{largest}"

# remove the largest
res = res -- [Enum.max(res)]

largest2 = Enum.max(res)
IO.puts "2nd largest integer: #{largest2}"

# remove the 2nd largest
res = res -- [Enum.max(res)]

largest3 = Enum.max(res)
IO.puts "3rd largest integer: #{largest3} "

total = largest + largest2 + largest3
IO.puts "TOTAL: #{total}"
