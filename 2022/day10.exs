# Read the input into memory, split on newline
{:ok, filecontents} = File.read("input/day10t.txt")
filecontents = filecontents |> String.split("\n", trim: true)
filecontents = Enum.map(filecontents, fn x -> String.graphemes(x) end)

IO.inspect filecontents

# Start by figuring out the signal being sent by the CPU. The CPU has a single register, X, which starts with the value 1. It supports only two instructions:

# addx V takes two cycles to complete. After two cycles, the X register is increased by the value V. (V can be negative.)
# noop takes one cycle to complete. It has no other effect.

result = Enum.map_reduce(
  Enum.to_list(0..length(filecontents) - 1),
  [],
  fn counter, acc ->
    instruction = Enum.fetch!(filecontents, counter)
    case instruction do
      ["a", "d", "d", "x", " " | tail] ->
        {2, acc ++ [{"add",
        elem(Integer.parse(Enum.reduce(tail, fn x, acc -> acc <> x end)), 0)}]}
      ["a", "d", "d", "x", " ", "-" | tail] ->
        {2, acc ++ [{"add",
        elem(Integer.parse(Enum.reduce(tail, fn x, acc -> acc <> x end)), 0)}]}
      ["n", "o", "o", "p"] ->
        {1, acc ++ [{"noop", 0}]}
      other ->
        IO.inspect {"Unexpected instruction:", other}
    end
  end
)

timingslist = elem(result, 0)
operationslist = elem(result, 1)

IO.inspect "timings"
IO.inspect timingslist
IO.inspect "ops"
IO.inspect operationslist

result = Enum.map_reduce(
  0..length(timingslist)-1,
  [%{clock: 0, xreg: 1}],
  fn index, acc ->
    timing = Enum.fetch!(timingslist, index)
    oparg = elem(Enum.fetch!(operationslist, index), 1)
    currentclock = hd(acc).clock
    currentxreg = hd(acc).xreg

    case timing do
      2 ->
        {oparg, [
          %{clock: currentclock+2, xreg: currentxreg},
          %{clock: currentclock+1, xreg: currentxreg},
        ] ++ acc}
      1 ->
        {oparg, [
          %{clock: currentclock, xreg: currentxreg}
        ] ++ acc}
      other ->
        IO.inspect "error: unknown timing!!!"
        IO.inspect other
        IO.inspect index
        IO.inspect acc
        Proess.sleep(10000)
    end
  end
)

IO.inspect Enum.reverse(elem(result, 1))
IO.inspect result
