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
        IO.inspect "error: impossible move!"
        IO.inspect {
          "pos", pos,
          "current_tl", current_tl,
          "diff", diff
        }
        Process.sleep(10000)
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
      # ====================
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
      # ====================
      %{x: 1, y: 2} ->
        %{x: currentpos.x + 1, y: currentpos.y + 1}
      %{x: 1, y: -2} ->
        %{x: currentpos.x + 1, y: currentpos.y - 1}
      %{x: -1, y: 2} ->
        %{x: currentpos.x - 1, y: currentpos.y + 1}
      %{x: -1, y: -2} ->
        %{x: currentpos.x - 1, y: currentpos.y - 1}
      other ->
        IO.inspect "error: impossible move!"
        IO.inspect {
          "pos", currentpos,
          "aheadpos", aheadpos,
          "diff", diff
        }
        Process.sleep(10000)
    end
  end

  def update_all_knot_positions(rope_configuration) do
    # IO.inspect("update_all_knot_positions")
    # IO.inspect(rope_configuration)

    if length(Map.keys(rope_configuration)) === 1 do
      # Base case: The head is already updated
      rope_configuration
    else
      # Start with the largest knot number (the tail)
      # and work our way to the head (base case),
      # and then work back up recursively to the tail with updates
      largest_knot_num = hd(
        Enum.sort(
          Enum.filter(Map.keys(rope_configuration), fn x -> x !== :head end),
          &(&1 >= &2)
        )
      )
      {pos, rope_configuration} = Map.pop!(rope_configuration, largest_knot_num)

      # Recursion!
      rope_configuration = update_all_knot_positions(rope_configuration)

      # Update the knot after
      rope_configuration = Map.put(
        rope_configuration,
        largest_knot_num,
        KnotMovement.get_new_position_for_knot(
          pos,
          if largest_knot_num === 1 do
            Map.fetch!(rope_configuration, :head)
          else
            Map.fetch!(rope_configuration, largest_knot_num-1)
          end
        )
      )
      rope_configuration
    end

    # This doesn't work! Why? Because we're comparing against the position
    # of the knot ahead in the *previous configuration*! We need to use a method
    # which allows us to access the result of the get_new_position_for_knot
    # function for the knot ahead and use it in our current calculation
    #
    # result = for {k, v} <- rope_configuration, into: %{} do
    #   if k === :head do
    #     # The head is already updated
    #     {k, v}
    #   else
    #     # Update position
    #     currentpos = v
    #     # we compare against :head
    #     aheadpos = Map.fetch!(rope_configuration, if k === 1 do :head else k - 1 end)
    #     # IO.inspect {"knotnum", k}
    #     {k, KnotMovement.get_new_position_for_knot(currentpos, aheadpos)}
    #   end
    # end
  end

end

# Read the input into memory, split on newline -- this stays the same
{:ok, filecontents} = File.read("input/day9.txt")
filecontents = filecontents |> String.split("\n", trim: true)
filecontents = Enum.map(filecontents, fn x -> String.graphemes(x) end)

filecontents = Enum.map(filecontents, fn [head | tail] ->
  tail = Enum.drop(tail, 1)
  dist = Enum.reduce(tail, fn x, acc -> acc <> x end)
  %{:dir => head, :dist => elem(Integer.parse(dist), 0)}
end)

start = %{:x => 0, :y => 0} # head and tail both start here

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

number_of_knots = 9

knotcoords = Enum.map_reduce(headcoords, [], fn pos, prevposlist ->
    if length(prevposlist) > 0 do
      last_config = Enum.fetch!(prevposlist, length(prevposlist) - 1)
      current_num_knots = length(Map.keys(last_config))

      if current_num_knots <= number_of_knots do
        # we need to add a new knot to the map, at the origin
        new_config = Map.put(last_config, current_num_knots, %{x: 0, y: 0})
        # update other knots' positions, head first
        new_config = Map.replace!(new_config, :head, pos)

        { %{x: 0, y: 0}, prevposlist ++ [KnotMovement.update_all_knot_positions(new_config)] }
      else
        # We now have all knots, just update their positions
        new_config = Map.replace!(last_config, :head, pos)

        { %{x: 0, y: 0}, prevposlist ++ [KnotMovement.update_all_knot_positions(new_config)] }
      end
    else
      # First step
      new_config = %{
        :head => pos
      }

      { %{x: 0, y: 0}, prevposlist ++ [new_config] }
    end
  end
)

defmodule VisualiseLongRope do
  def print_all_moves(inputlist) do
    IO.write "\e[H\e[J";
    Enum.map(
      Enum.with_index(inputlist), fn x ->
        VisualiseLongRope.print_single_move(elem(x, 0), elem(x, 1))
      end
    )
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

    # We need to invert our map
    # (swap keys (knot #s) with values (coords))
    pos_map = Map.new(move, fn {knot, pos} -> {pos, knot} end)

    for ycoord <- maxy..miny do
      for xcoord <- minx..maxx do
        currentpos = %{x: xcoord, y: ycoord}

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
            # Draw Head / tail / 1,2,3, etc
            if Map.has_key?(pos_map, currentpos) do
              knot = Map.fetch!(pos_map, currentpos)
              IO.write(if knot === :head do "H" else knot end)
              IO.write("  ")
            else
              # Draw lines or spaces as appropriate
              if ycoord === 0 do
                IO.write("───")
              else
                if xcoord === 0 do
                  IO.write("│  ")
                else
                  IO.write("░  ")
                end
              end
            end
          end
        end
      end
      IO.write("\n")
    end

    # IO.inspect move
    # IO.inspect "==="
    # IO.inspect pos_map

    Process.sleep(800)
  end
end

VisualiseLongRope.print_all_moves(elem(knotcoords, 1))

all_tail_positions = Enum.map(elem(knotcoords, 1), fn posmap ->
    tailpos = Map.fetch(
      posmap, number_of_knots
    )
    if tailpos === :error do
      %{x: 0, y: 0}
    else
      elem(tailpos, 1)
    end
  end
)

IO.inspect length(Enum.uniq(all_tail_positions))
