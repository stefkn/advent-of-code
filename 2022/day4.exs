# Read the file into memory
{:ok, filecontents} = File.read("input/day4.txt")

# Split input into list of strings on newline "71-71,42-72"
splitcontents = filecontents |> String.split("\n", trim: true)

# Split each string on the comma to make lists of each pair [["71-71", "42-72"],]
pairs = Enum.map(splitcontents, fn x -> String.split(x, ",", trim: true) end)

# split integers out into their own strings [[["71", "71"], ["42", "72"]],]
stringlists = Enum.map(pairs, fn [a, b] -> [
  String.split(a, "-",   trim: true),
  String.split(b, "-", trim: true)
] end)

# https://stackoverflow.com/questions/65135280/why-does-for-x-3-4-do-x-3-return-t-f-in-elixir/65136734#65136734
# ['GG', '*H']... looks wrong but lists of integers in the ASCII range (0-127) get represented as charlists, all good
intlists = Enum.map(stringlists, fn [[a, b],[c, d]] -> [
  [ elem(Integer.parse(a), 0), elem(Integer.parse(b), 0) ],
  [ elem(Integer.parse(c), 0), elem(Integer.parse(d), 0) ]
] end)

# [ [#MapSet<[71..71]>, #MapSet<[42..72]>], ...
rangesets = Enum.map(intlists, fn [[a, b],[c, d]] -> [
  MapSet.new(Enum.to_list(a..b)),
  MapSet.new(Enum.to_list(c..d))
] end)

# Check if either MapSet's intersection is wholly equal to either of the MapSets
subsets = Enum.map(rangesets, fn [a, b] ->
  MapSet.equal?(MapSet.intersection(a, b), a)
  ||
  MapSet.equal?(MapSet.intersection(a, b), b)
  ||
  MapSet.equal?(MapSet.intersection(b, a), a)
  ||
  MapSet.equal?(MapSet.intersection(b, a), b)
end)

# Count the trues!
IO.inspect Enum.reduce(subsets, 0, fn x, acc -> if x, do: 1 + acc, else: 0 + acc end)

# Part 2
subsets = Enum.map(rangesets, fn [a, b] ->
  MapSet.disjoint?(a, b)
  &&
  MapSet.disjoint?(b, a)
end)

# Count the trues!
IO.inspect Enum.reduce(subsets, 0, fn x, acc -> if !x, do: 1 + acc, else: 0 + acc end)
