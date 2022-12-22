# encode the list of all atoms in a tuple
priorities = Enum.with_index(
  [:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k,:l,:m,:n,:o,:p,:q,:r,:s,:t,:u,:v,:w,:x,:y,:z,
  :A,:B,:C,:D,:E,:F,:G,:H,:I,:J,:K,:L,:M,:N,:O,:P,:Q,:R,:S,:T,:U,:V,:W,:X,:Y,:Z]
)

# Read the file into memory
{:ok, filecontents} = File.read("input/day3.txt")

# Split input into list of strings on newline
splitcontents = filecontents |> String.split("\n", trim: true)

# take each line (each backpack contents) and split into tuples of MapSets for each backpack
defmodule Recursion do
  # Recursive step
  def iterate_through_backpacks(tupleslist, n, result, priorities) when n > 0 do
    # Get the nth element
    {:ok, elem} = Enum.fetch(tupleslist, length(tupleslist) - n)

    tuple = {
      MapSet.new(
        String.graphemes(
          String.slice(elem, 0, div(String.length(elem), 2))
        )
      ),
      MapSet.new(
        String.graphemes(
          String.slice(elem, div(String.length(elem), 2), String.length(elem))
        )
      )
    }

    # Get the intersection of the two compartments of the backpack
    intersection = MapSet.intersection(
      elem(tuple,0), elem(tuple,1)
    )

    IO.inspect MapSet.to_list(intersection)

    # get the priority from our list
    duplicateitem = String.to_existing_atom(hd(MapSet.to_list(intersection)))

    IO.inspect duplicateitem

    # find the matching priority in the priorities list
    {atom, priority} = Enum.find(
      priorities, fn(element) ->
        match?({^duplicateitem, priority}, element)
      end
    )

    # Accumulate the result... remember, the priority is one less than the acutal priority because it is zero indexed! so we add one here.
    result = result + priority + 1

    iterate_through_backpacks(tupleslist, n - 1, result, priorities)
  end

  # base case
  def iterate_through_backpacks(tupleslist, 0, result, priorities) do
    {:ok, result}
  end
end

{:ok, res} = Recursion.iterate_through_backpacks(splitcontents, length(splitcontents), 0, priorities)

IO.inspect res

# encode the list of all atoms in a tuple
priorities = Enum.with_index([:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k,:l,:m,:n,:o,:p,:q,:r,:s,:t,:u,:v,:w,:x,:y,:z, :A,:B,:C,:D,:E,:F,:G,:H,:I,:J,:K,:L,:M,:N,:O,:P,:Q,:R,:S,:T,:U,:V,:W,:X,:Y,:Z])

# Read the file into memory
{:ok, filecontents} = File.read("input/day3.txt")

# Split input into list of strings on newline
splitcontents = filecontents |> String.split("\n", trim: true)

# take each line (each backpack contents) and split into tuples of MapSets for each backpack
defmodule Recursion do
  # Recursive step
  def iterate_through_backpacks(tupleslist, n, result, priorities) when n > 0 do
    # Get the group's backpacks
    {:ok, elem1} = Enum.fetch(tupleslist, length(tupleslist) - n)
    {:ok, elem2} = Enum.fetch(tupleslist, length(tupleslist) - n + 1)
    {:ok, elem3} = Enum.fetch(tupleslist, length(tupleslist) - n + 2)

    IO.puts "================"
    IO.inspect elem1
    IO.inspect elem2
    IO.inspect elem3

    elem1 = MapSet.new(
      String.graphemes(
        elem1
      )
    )

    elem2 = MapSet.new(
      String.graphemes(
        elem2
      )
    )

    elem3 = MapSet.new(
      String.graphemes(
        elem3
      )
    )

    # Get the intersection of all the groups backpacks
    intersection = MapSet.intersection(
      MapSet.intersection(
        elem1, elem2
      ), elem3
    )

    # get the priority from our list
    duplicateitem = String.to_existing_atom(hd(MapSet.to_list(intersection)))

    # find the matching priority in the priorities list
    {atom, priority} = Enum.find(
      priorities, fn(element) ->
        match?({^duplicateitem, priority}, element)
      end
    )

    # Accumulate the result... remember, the priority is one less than the acutal priority because it is zero indexed! so we add one here.
    result = result + priority + 1

    iterate_through_backpacks(tupleslist, n - 3, result, priorities)
  end

  # base case
  def iterate_through_backpacks(tupleslist, 0, result, priorities) do
    {:ok, result}
  end
end

{:ok, res} = Recursion.iterate_through_backpacks(splitcontents, length(splitcontents), 0, priorities)

IO.inspect res
