# Read the stack input into memory
{:ok, filecontents} = File.read("input/day6.txt")

# split the one massive long string into a list of graphemes (chars)
graphemes = String.graphemes(filecontents)

n = 50000 # how long to compare for, just make this larger than the input string length
uniquelength = 4 # how long the unique string has to be

chars_until_marker = Enum.flat_map_reduce(
  graphemes, [],
  fn x, acc ->
    if length(acc) > uniquelength - 1 && length(acc) < n do
      # grab the last 0-uniquelength chars to check against
      currentchars = Enum.map(Enum.to_list(0..uniquelength - 1), fn x -> Enum.at(acc, x) end)
      # if they are all unique, halt and return, otherwise add the latest on to the accumulator and keep going
      if length(Enum.uniq(currentchars)) === uniquelength do
        {:halt, acc}
      else
        {[x], [x] ++ acc}
      end
    else
      # keep going, we don't have enough to compare against yet
      if length(acc) < n, do: {[x], [x] ++ acc}, else: {:halt, acc}
    end
  end
)

IO.inspect length(elem(chars_until_marker,1)) # the length of the string we get back is our answer!
