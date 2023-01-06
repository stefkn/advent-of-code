# Read the input into memory, split on newline
{:ok, filecontents} = File.read("input/day8.txt")
filecontents = filecontents |> String.split("\n", trim: true)
filecontents = Enum.map(filecontents, fn x -> String.graphemes(x) end)

# Parse all strings into a list of ints
rowgrid = Enum.map(filecontents, fn x ->
  Enum.map(x, fn x ->
      elem(Integer.parse(x), 0)
    end
  )
  end
)

# Thanks to https://elixirforum.com/t/transpose-a-list-of-lists-using-list-comprehension/17638/2
defmodule Transp do
  def transpose([[] | _]), do: []
  def transpose(m) do
    [Enum.map(m, &hd/1) | transpose(Enum.map(m, &tl/1))]
  end
end

colgrid = Transp.transpose(rowgrid)

IO.inspect rowgrid
IO.inspect colgrid

# Now we have two lists of lists, one representing the rows, one representing the columns.
# If a tree is visible in either one, it is visible.
# Therefore, if we can create a visibility map of both, and then take the AND of both, we have our overall visibility.

defmodule CheckVis do
  def is_visible_in_list(row, height, index) do
    # IO.inspect "is_visible_in_list=========================r,h,i"
    # IO.inspect {row, height, index}

    # is it first or last in the row (at the edge of the forest)
    if index === 0 || index === length(row) - 1 do
      1
    else
      # Look back
      lookback = Enum.reduce(Enum.reverse(Enum.to_list(0..index-1)), 1, fn i, acc ->
        # IO.inspect {"lb elem, height", elem(Enum.fetch(row, i), 1), height}
        if elem(Enum.fetch(row, i), 1) < height do
          if acc == 0, do: 0, else: 1 # if it's already occluded (hidden by a taller tree before) it stays hidden
        else
          0 # hidden by a taller tree
        end
      end)
      # Look forward
      lookfwd = Enum.reduce(Enum.to_list(index+1..length(row)-1), 1, fn i, acc ->
        # IO.inspect {"lf elem, height", elem(Enum.fetch(row, i), 1), height}
        if elem(Enum.fetch(row, i), 1) < height do
          if acc == 0, do: 0, else: 1 # if it's already occluded (hidden by a taller tree before) it stays hidden
        else
          0 # hidden by a taller tree
        end
      end)
      # IO.inspect {lookback, lookfwd}
      lookback + lookfwd
    end
  end
end

rowgridvis = Enum.map(rowgrid, fn row ->
  Enum.map(Enum.with_index(row), fn tree ->
      CheckVis.is_visible_in_list(row, elem(tree, 0), elem(tree, 1))
    end
  )
  end
)

colgridvis = Enum.map(colgrid, fn row ->
  Enum.map(Enum.with_index(row), fn tree ->
      CheckVis.is_visible_in_list(row, elem(tree, 0), elem(tree, 1))
    end
  )
  end
)

# Now we have two matrixes (rows and cols) where, for each index, the tree at that index is either 0 = not visible, 1 = visible in one direction, or 2 = visible in both directions.

IO.inspect rowgridvis
IO.inspect colgridvis

totalvis = Enum.map(Enum.with_index(rowgridvis), fn {row, rowindex} ->
  Enum.map(Enum.with_index(row), fn {treeheight, inrowindex} ->
      treeheight + Enum.fetch!(Enum.fetch!(colgridvis, inrowindex), rowindex)
    end
  )
  end
)

IO.inspect totalvis

# To find the total number of visible trees, we just count how many trees have >0 degrees of visibility!

IO.inspect Enum.reduce(totalvis, 0, fn x, acc ->
  acc + Enum.reduce(x, 0, fn y, acc2 ->
    acc = if y > 0, do: acc2 + 1, else: acc2
  end)
end)



# Part 2 ==============================================================

# Read the input into memory, split on newline
{:ok, filecontents} = File.read("input/day8.txt")
filecontents = filecontents |> String.split("\n", trim: true)
filecontents = Enum.map(filecontents, fn x -> String.graphemes(x) end)

# Parse all strings into a list of ints
rowgrid = Enum.map(filecontents, fn x ->
  Enum.map(x, fn x ->
      elem(Integer.parse(x), 0)
    end
  )
  end
)

# Thanks to https://elixirforum.com/t/transpose-a-list-of-lists-using-list-comprehension/17638/2
defmodule Transp do
  def transpose([[] | _]), do: []
  def transpose(m) do
    [Enum.map(m, &hd/1) | transpose(Enum.map(m, &tl/1))]
  end
end

colgrid = Transp.transpose(rowgrid)

IO.inspect rowgrid
IO.inspect colgrid

# Now we have two lists of lists, one representing the rows, one representing the columns.
# If a tree is visible in either one, it is visible.
# Therefore, if we can create a visibility map of both, and then take the AND of both, we have our overall visibility.

defmodule CheckVis do
  def is_visible_in_list(row, height, index) do
    # is it first or last in the row (at the edge of the forest)
    if index === 0 || index === length(row) - 1 do
      IO.inspect {0,0}
      {0, 0}
    else
      # Look back
      lookback = Enum.reduce(Enum.reverse(Enum.to_list(0..index-1)), {0, :notdone}, fn i, acc ->
        if elem(acc, 1) === :notdone do
          if elem(Enum.fetch(row, i), 1) < height do
            {elem(acc, 0) +1, :notdone} # count +1 visible tree
          else
            if elem(acc, 0) === 0, do: {1, :done}, else: {elem(acc, 0) + 1, :done} # hidden by a taller tree
          end
        else
          {elem(acc, 0), :done}
        end
      end)
      # Look forward
      lookfwd = Enum.reduce(Enum.to_list(index+1..length(row)-1), {0, :notdone}, fn i, acc ->
        if elem(acc, 1) === :notdone do
          if elem(Enum.fetch(row, i), 1) < height do
            {elem(acc, 0) +1, :notdone} # count +1 visible tree
          else
            if elem(acc, 0) === 0, do: {1, :done}, else: {elem(acc, 0) + 1, :done} # hidden by a taller tree
          end
        else
          {elem(acc, 0), :done}
        end
      end)
      {elem(lookback, 0), elem(lookfwd, 0)}
    end
  end
end

rowgridvis = Enum.map(rowgrid, fn row ->
  Enum.map(Enum.with_index(row), fn tree ->
      CheckVis.is_visible_in_list(row, elem(tree, 0), elem(tree, 1))
    end
  )
  end
)

colgridvis = Enum.map(colgrid, fn row ->
  Enum.map(Enum.with_index(row), fn tree ->
      CheckVis.is_visible_in_list(row, elem(tree, 0), elem(tree, 1))
    end
  )
  end
)

# We now multiply together each of the scenic scores for up, down, left and right

totalvis = Enum.map(Enum.with_index(rowgridvis), fn {row, rowindex} ->
  Enum.map(Enum.with_index(row), fn {treeheight, inrowindex} ->
      elem(treeheight, 0) *
      elem(Enum.fetch!(Enum.fetch!(colgridvis, inrowindex), rowindex), 0) *
      elem(treeheight, 1) *
      elem(Enum.fetch!(Enum.fetch!(colgridvis, inrowindex), rowindex), 1)
    end
  )
  end
)

# Get the maximum of every row, and get the maximum of those
IO.inspect Enum.max(Enum.map(totalvis, fn x -> Enum.max(x) end))
