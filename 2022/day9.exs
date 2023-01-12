# Read the input into memory, split on newline
{:ok, filecontents} = File.read("input/day9.txt")
filecontents = filecontents |> String.split("\n", trim: true)
filecontents = Enum.map(filecontents, fn x -> String.graphemes(x) end)

filecontents = Enum.map(filecontents, fn [head | tail] ->
  tail = Enum.drop(tail, 1)
  dist = Enum.reduce(tail, fn x, acc -> acc <> x end)
  %{:dir => head, :dist => elem(Integer.parse(dist), 0)}
end)

start = %{:x => 0, :y => 0} # head and tail both start here

# IO.inspect filecontents

headcoords = elem(Enum.map_reduce(filecontents, [start], fn move, prevposlist ->
  prevx = Enum.fetch!(prevposlist, length(prevposlist) - 1).x
  prevy = Enum.fetch!(prevposlist, length(prevposlist) - 1).y
  case move do
    %{dir: "L", dist: d} ->
      {"L", prevposlist ++ Enum.map(
        Enum.to_list(1..d), fn step -> %{:x => prevx - step, :y => prevy}
      end)}
    %{dir: "R", dist: d} ->
      {"R", prevposlist ++ Enum.map(
        Enum.to_list(1..d), fn step -> %{:x => prevx + step, :y => prevy}
      end)}
    %{dir: "U", dist: d} ->
      {"L", prevposlist ++ Enum.map(
        Enum.to_list(1..d), fn step -> %{:x => prevx, :y => prevy + step}
      end)}
    %{dir: "D", dist: d} ->
      {"L", prevposlist ++ Enum.map(
        Enum.to_list(1..d), fn step -> %{:x => prevx, :y => prevy - step}
      end)}
  end
end), 1)

# IO.inspect headcoords

tailcoords = Enum.map_reduce(headcoords, [], fn pos, prevposlist ->

  if length(prevposlist) <= 1 do
    # first and second step we don't move
    { %{x: 0, y: 0}, prevposlist ++ [%{tail: %{x: 0, y: 0}, head: pos}] }
  else
    current_tl = Enum.fetch!(prevposlist, length(prevposlist) - 1).tail
    diff = %{ x: pos.x - current_tl.x, y: pos.y - current_tl.y }

    case diff do
      # ==================== No move
      %{x: 0, y: 0} ->
        { current_tl,
        prevposlist ++ [%{tail: current_tl, head: pos}] }
      # ==================== Straight moves
      %{x: 2, y: 0} ->
        { %{x: current_tl.x + 1, y: current_tl.y},
        prevposlist ++ [%{tail: %{x: current_tl.x + 1, y: current_tl.y}, head: pos}] }
      %{x: 0, y: 2} ->
        { %{x: current_tl.x, y: current_tl.y + 1},
        prevposlist ++ [%{tail: %{x: current_tl.x, y: current_tl.y + 1}, head: pos}] }
      %{x: -2, y: 0} ->
        { %{x: current_tl.x - 1, y: current_tl.y},
        prevposlist ++ [%{tail: %{x: current_tl.x - 1, y: current_tl.y}, head: pos}] }
      %{x: 0, y: -2} ->
        { %{x: current_tl.x, y: current_tl.y - 1},
        prevposlist ++ [%{tail: %{x: current_tl.x, y: current_tl.y - 1}, head: pos}] }
      # ==================== 1-1 Diagonal moves
      %{x: 1, y: 1} ->
        { current_tl,
        prevposlist ++ [%{tail: current_tl, head: pos}] }
      %{x: -1, y: 1} ->
        { current_tl,
        prevposlist ++ [%{tail: current_tl, head: pos}] }
      %{x: 1, y: -1} ->
        { current_tl,
        prevposlist ++ [%{tail: current_tl, head: pos}] }
      %{x: -1, y: -1} ->
        { current_tl,
        prevposlist ++ [%{tail: current_tl, head: pos}] }
      # ==================== 1-0 Diagonal moves
      %{x: 0, y: 1} ->
        { current_tl,
        prevposlist ++ [%{tail: current_tl, head: pos}] }
      %{x: 1, y: 0} ->
        { current_tl,
        prevposlist ++ [%{tail: current_tl, head: pos}] }
      %{x: 0, y: -1} ->
        { current_tl,
        prevposlist ++ [%{tail: current_tl, head: pos}] }
      %{x: -1, y: 0} ->
        { current_tl,
        prevposlist ++ [%{tail: current_tl, head: pos}] }
      # ==================== 1-2 / 2-1 Diagonal moves
      %{x: 2, y: 1} ->
        { %{x: current_tl.x + 1, y: current_tl.y + 1},
        prevposlist ++ [%{tail: %{x: current_tl.x + 1, y: current_tl.y + 1}, head: pos}] }
      %{x: -2, y: 1} ->
        { %{x: current_tl.x - 1, y: current_tl.y + 1},
        prevposlist ++ [%{tail: %{x: current_tl.x - 1, y: current_tl.y + 1}, head: pos}] }
      %{x: 2, y: -1} ->
        { %{x: current_tl.x + 1, y: current_tl.y - 1},
        prevposlist ++ [%{tail: %{x: current_tl.x + 1, y: current_tl.y - 1}, head: pos}] }
      %{x: -2, y: -1} ->
        { %{x: current_tl.x - 1, y: current_tl.y - 1},
        prevposlist ++ [%{tail: %{x: current_tl.x - 1, y: current_tl.y - 1}, head: pos}] }
      %{x: 1, y: 2} ->
        { %{x: current_tl.x + 1, y: current_tl.y + 1},
        prevposlist ++ [%{tail: %{x: current_tl.x + 1, y: current_tl.y + 1}, head: pos}] }
      %{x: 1, y: -2} ->
        { %{x: current_tl.x + 1, y: current_tl.y - 1},
        prevposlist ++ [%{tail: %{x: current_tl.x + 1, y: current_tl.y - 1}, head: pos}] }
      %{x: -1, y: 2} ->
        { %{x: current_tl.x - 1, y: current_tl.y + 1},
        prevposlist ++ [%{tail: %{x: current_tl.x - 1, y: current_tl.y + 1}, head: pos}] }
      %{x: -1, y: -2} ->
        { %{x: current_tl.x - 1, y: current_tl.y - 1},
        prevposlist ++ [%{tail: %{x: current_tl.x - 1, y: current_tl.y - 1}, head: pos}] }
      other ->
        IO.inspect {"--------------------other", other}
        IO.inspect {"pos", pos, "prevpos", prevposlist}
        { %{x: current_tl.x, y: current_tl.y},
        prevposlist ++ [%{tail: %{x: current_tl.x, y: current_tl.y}, head: pos}] }
    end
  end
end)

# IO.inspect tailcoords
# IO.inspect length(Enum.uniq(elem(tailcoords, 0)))

defmodule Visualise do
  def print_all_moves(inputlist) do
    IO.write "\e[H\e[J";
    Enum.map(
      Enum.with_index(inputlist), fn x -> Visualise.print_single_move(elem(x, 0), elem(x, 1))
    end)
  end

  def print_single_move(move, index) do
    IO.write "\e[H\e[J";
    IO.write("index: ")
    IO.write(index)
    IO.write("\n")
    minx = -19
    miny = -20
    maxx = 19
    maxy = 20

    for ycoord <- maxy..miny do
      for xcoord <- minx..maxx do
        if ycoord === miny do
          # Draw legend
          # make them line up better
          IO.write(if abs(xcoord) < 10 do abs(xcoord) else abs(xcoord)-10 end)
          IO.write("  ")
        else
          if xcoord === maxx do
            # Draw legend
            IO.write(ycoord)
          else
            # Draw Head / tail / etc
            if xcoord === move.head.x && ycoord === move.head.y do
              IO.write("H  ")
            else
              if xcoord === move.tail.x && ycoord === move.tail.y do
                IO.write("T  ")
              else
                if ycoord === 0 do
                  IO.write("───")
                else
                  if xcoord === 0 do
                    IO.write("│  ")
                  else
                    IO.write("▓  ")
                  end
                end
              end
            end
          end
        end
      end
      IO.write("\n")
    end
    Process.sleep(3000)
    # IO.inspect move.head
    # IO.inspect move.tail
  end
end

Visualise.print_all_moves(elem(tailcoords, 1))










# Part 2 =============================================================
# Rather than two knots, you now must simulate a rope consisting of ten knots. One knot is still the head of the rope and moves according to the series of motions. Each knot further down the rope follows the knot in front of it using the same rules as before.

# We need to refactor -- break out the movement logic into its own discrete function
defmodule KnotMovement do
  def get_new_position_for_knot(currentpos, aheadpos) do
    # IO.inspect "========get_new_position_for_knot========="
    # IO.inspect currentpos
    # IO.inspect aheadpos
    # IO.write("\n")
    # Process.sleep(3000)

    diff = %{ x: aheadpos.x - currentpos.x, y: aheadpos.y - currentpos.y }

    case diff do
      # ==================== No move
      %{x: 0, y: 0} ->
        currentpos
      # ==================== Straight moves
      %{x: 2, y: 0} ->
        %{x: currentpos.x + 1, y: currentpos.y}
      %{x: 0, y: 2} ->
        %{x: currentpos.x, y: currentpos.y + 1}
      %{x: -2, y: 0} ->
        %{x: currentpos.x - 1, y: currentpos.y}
      %{x: 0, y: -2} ->
        %{x: currentpos.x, y: currentpos.y - 1}
      #
      %{x: -2, y: -2} ->
        %{x: currentpos.x - 1, y: currentpos.y - 1}
      %{x: 2, y: -2} ->
        %{x: currentpos.x + 1, y: currentpos.y - 1}
      %{x: 2, y: 2} ->
        %{x: currentpos.x + 1, y: currentpos.y + 1}
      %{x: -2, y: 2} ->
        %{x: currentpos.x - 1, y: currentpos.y + 1}
      # ==================== 1-1 Diagonal moves
      %{x: 1, y: 1} ->
        currentpos
      %{x: -1, y: 1} ->
        currentpos
      %{x: 1, y: -1} ->
        currentpos
      %{x: -1, y: -1} ->
        currentpos
      # ==================== 1-0 Diagonal moves
      %{x: 0, y: 1} ->
        currentpos
      %{x: 1, y: 0} ->
        currentpos
      %{x: 0, y: -1} ->
        currentpos
      %{x: -1, y: 0} ->
        currentpos
      # ==================== 1-2 / 2-1 Diagonal moves
      %{x: 2, y: 1} ->
        %{x: currentpos.x + 1, y: currentpos.y + 1}
      %{x: -2, y: 1} ->
        %{x: currentpos.x - 1, y: currentpos.y + 1}
      %{x: 2, y: -1} ->
        %{x: currentpos.x + 1, y: currentpos.y - 1}
      %{x: -2, y: -1} ->
        %{x: currentpos.x - 1, y: currentpos.y - 1}

      %{x: 1, y: 2} ->
        %{x: currentpos.x + 1, y: currentpos.y + 1}
      %{x: 1, y: -2} ->
        %{x: currentpos.x + 1, y: currentpos.y - 1}
      %{x: -1, y: 2} ->
        %{x: currentpos.x - 1, y: currentpos.y + 1}
      %{x: -1, y: -2} ->
        %{x: currentpos.x - 1, y: currentpos.y - 1}
      other ->
        IO.inspect {"--------------------other!!!", other}
        IO.inspect {"pos", currentpos, "aheadpos", aheadpos, "diff", diff}
        Process.sleep(5000)
        %{x: currentpos.x, y: currentpos.y}
    end
  end
