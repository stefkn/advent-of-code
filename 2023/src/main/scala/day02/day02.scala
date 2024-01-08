package day02

def day2p1(data: String): Int =
  val bag = Map(
    "red" -> 12, 
    "green" -> 13,
    "blue" -> 14
  )

  def isPossibleRound(string: String): Boolean =
    val rounds = string.split(':').last

    for color <- bag.keys do
      val indexOfColor = rounds.indexOf(color)
      val bagColorNum = bag(color)
      if indexOfColor != -1 then
        val roundsColorNum = rounds.take(indexOfColor).split(',').last.strip().toInt
        if roundsColorNum > bagColorNum then 
          return false

    return true
  end isPossibleRound

  def getPossibleGameNumbers(string: String): Int =
    val gameNum = string.stripPrefix("Game ").takeWhile(_.isDigit).toInt
    val rounds = string.split(": ").last.split(";")

    for round <- rounds do
      if !isPossibleRound(round) then
        return 0
    return gameNum
  end getPossibleGameNumbers

  val totalSum = data
    .linesIterator
    .map(getPossibleGameNumbers(_))
    .sum
  return totalSum
end day2p1

