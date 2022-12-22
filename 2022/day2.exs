# define atoms
_a = :A
_b = :B
_c = :C
_x = :X
_y = :Y
_z = :Z
_w = :win
_l = :loss
_d = :draw

# encode all possible game outcomes in a map
game_map = %{
  {:A, :X} => :draw,
  {:A, :Y} => :win,
  {:A, :Z} => :loss,
  {:B, :X} => :loss,
  {:B, :Y} => :draw,
  {:B, :Z} => :win,
  {:C, :X} => :win,
  {:C, :Y} => :loss,
  {:C, :Z} => :draw,
}

# encode the points system in another map
points_map = %{
  :X => 1,
  :Y => 2,
  :Z => 3,
  :win => 6,
  :loss => 0,
  :draw => 3,
}

# Read the file into memory
{:ok, filecontents} = File.read("day2.txt")

# Split input into list of strings on newline
splitcontents = filecontents |> String.split("\n", trim: true)

# Parse (cast) bytestrings into tuples with atoms inside -- this step will fail if you pass anything in that isn't a binary (beware some bitstrings can be valid, but not valid binaries, e.g. <<3::4>>) as it uses to_existing_atom
tupleslist = Enum.map(
  splitcontents,
  fn
    x -> {
      String.to_existing_atom(String.at(x,0)),
      String.to_existing_atom(String.at(x,2))
    }
  end
)

# Define a recursive function to assign outcomes to the list
defmodule Recursion do
  # Recursive step
  def iterate_through_games(tupleslist, n, result, game_map, points_map) when n > 0 do
    # Get the nth element
    {:ok, elem} = Enum.fetch(tupleslist, length(tupleslist) - n)

    IO.inspect elem
    {x, y} = elem

    # points gained from the hand you played
    IO.inspect points_map[y]

    # the result of the game
    IO.inspect game_map[elem]

    # points gained from the result of the game
    IO.inspect points_map[game_map[elem]]

    # total points
    IO.inspect points_map[y] + points_map[game_map[elem]]

    # accumulate result
    result = result + points_map[y] + points_map[game_map[elem]]

    # recursion again!
    iterate_through_games(tupleslist, n - 1, result, game_map, points_map)
  end

  # base case
  def iterate_through_games(tupleslist, 0, result, game_map, points_map) do
    {:ok, result}
  end
end

{:ok, res} = Recursion.iterate_through_games(tupleslist, length(tupleslist), 0, game_map, points_map)

IO.inspect res
