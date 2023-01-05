# Part 1 ==========================================================

# Read the stack input into memory, split on newline
{:ok, filecontents} = File.read("input/day7.txt")
filecontents = filecontents |> String.split("\n", trim: true)

defmodule Recursion do
  # Recursive step
  def parse_all_commands(inslist, n, result, acc) when n > 0 do
    # Get the nth element
    current = length(inslist) - n
    {:ok, i} = Enum.fetch(inslist, current)

    case String.graphemes(i) do
      ["$", " ", "c", "d", " " | tail] ->
        # "$ cd {}"
        dirname = name = Enum.reduce(tail, fn x, acc -> acc <> x end)
        IO.inspect {"cd --- ", dirname}

        if dirname === ".." do
          if hd(result) < 100001 do
            acc = [hd(result) | acc]

            result = [hd(result) + hd(tl(result)) | tl(tl(result))]

            IO.inspect {"res: ", result, acc}
            parse_all_commands(inslist, n - 1, result, acc)
          else
            result = [hd(result) + hd(tl(result)) | tl(tl(result))]

            IO.inspect {"res: ", result, acc}
            parse_all_commands(inslist, n - 1, result, acc)
          end
        else
          result = [0 | result]

          IO.inspect {"res: ", result, acc}
          parse_all_commands(inslist, n - 1, result, acc)
        end

      ["$", " ", "l", "s"] ->
        # "$ ls {}"
        IO.inspect {"ls ------------------------- "}
        IO.inspect {"res: ", result, acc}
        parse_all_commands(inslist, n - 1, result, acc)

      ["d", "i", "r", " " | tail] ->
        # "$ dir {}"
        dirname = name = Enum.reduce(tail, fn x, acc -> acc <> x end)
        IO.inspect {"dr: ", dirname}
        IO.inspect {"res: ", result, acc}
        parse_all_commands(inslist, n - 1, result, acc)

      fileandsize ->
        # size, " ", name_of_file
        size = Enum.take_while(
          fileandsize,
          fn x -> x !== " "
        end)
        {sizeint, ""} = Integer.parse(
          Enum.reduce(size, fn x, acc -> acc <> x end)
        )

        name = Enum.take_while(
          Enum.drop(fileandsize, length(size) + 1),
          fn x -> x !== " "
        end)
        name = Enum.reduce(name, fn x, acc -> acc <> x end)

        IO.inspect {"fl: ", name, sizeint}
        result = [hd(result) + sizeint | tl(result)]

        IO.inspect {"res: ", result, acc}
        parse_all_commands(inslist, n - 1, result, acc)
    end
  end

  # base case
  def parse_all_commands(inslist, 0, result, acc) do
    {:ok, result, acc}
  end
end

{:ok, res, acc} = Recursion.parse_all_commands(
  filecontents,
  length(filecontents),
  [],
  []
)

IO.inspect Enum.sum(acc)


# Part 2 ==========================================================

# Read the stack input into memory, split on newline
{:ok, filecontents} = File.read("input/day7.txt")
filecontents = filecontents |> String.split("\n", trim: true)

defmodule Recursion do
  # Recursive step
  def parse_all_commands(inslist, n, result, acc) when n > 0 do
    # Get the nth element
    current = length(inslist) - n
    {:ok, i} = Enum.fetch(inslist, current)

    case String.graphemes(i) do
      ["$", " ", "c", "d", " " | tail] ->
        # "$ cd {}"
        dirname = name = Enum.reduce(tail, fn x, acc -> acc <> x end)
        IO.inspect {"cd --- ", dirname}

        if dirname === ".." do
          # if hd(result) < 100001 do
            acc = [hd(result) | acc]

            result = [hd(result) + hd(tl(result)) | tl(tl(result))]

            IO.inspect {"res: ", result, acc}
            parse_all_commands(inslist, n - 1, result, acc)
          # else
          #   result = [hd(result) + hd(tl(result)) | tl(tl(result))]

          #   IO.inspect {"res: ", result, acc}
          #   parse_all_commands(inslist, n - 1, result, acc)
          # end
        else
          result = [0 | result]

          IO.inspect {"res: ", result, acc}
          parse_all_commands(inslist, n - 1, result, acc)
        end

      ["$", " ", "l", "s"] ->
        # "$ ls {}"
        IO.inspect {"ls ------------------------- "}
        IO.inspect {"res: ", result, acc}
        parse_all_commands(inslist, n - 1, result, acc)

      ["d", "i", "r", " " | tail] ->
        # "$ dir {}"
        dirname = name = Enum.reduce(tail, fn x, acc -> acc <> x end)
        IO.inspect {"dr: ", dirname}
        IO.inspect {"res: ", result, acc}
        parse_all_commands(inslist, n - 1, result, acc)

      fileandsize ->
        # size, " ", name_of_file
        size = Enum.take_while(
          fileandsize,
          fn x -> x !== " "
        end)
        {sizeint, ""} = Integer.parse(
          Enum.reduce(size, fn x, acc -> acc <> x end)
        )

        name = Enum.take_while(
          Enum.drop(fileandsize, length(size) + 1),
          fn x -> x !== " "
        end)
        name = Enum.reduce(name, fn x, acc -> acc <> x end)

        IO.inspect {"fl: ", name, sizeint}
        result = [hd(result) + sizeint | tl(result)]

        IO.inspect {"res: ", result, acc}
        parse_all_commands(inslist, n - 1, result, acc)
    end
  end

  # base case
  def parse_all_commands(inslist, 0, result, acc) do
    {:ok, result, acc}
  end
end

{:ok, res, acc} = Recursion.parse_all_commands(
  filecontents,
  length(filecontents),
  [],
  []
)

totalspace = 70000000 - Enum.sum(res)
neededspace = 30000000

possible = Enum.filter(acc, fn x -> totalspace + x >= neededspace end)
sorted = Enum.sort(possible)

IO.inspect(hd(sorted))
