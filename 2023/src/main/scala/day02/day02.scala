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



def day2p2(data: String): Int =
  def getMinimumsForEachColorForRounds(round: String): Map[String, Int] =
    val bag = Map[String, Int](
      "red" -> 0, 
      "green" -> 0,
      "blue" -> 0
    ).withDefault(i => 0)

    val getMinimumsForRound: ((String, Int)) => (String, Int) = {
      case (color, count) =>
        val indexOfColor = round.indexOf(color)
        if indexOfColor != -1 then
          val roundsColorNum = round.take(indexOfColor).split(',').last.strip().toInt
          color -> roundsColorNum
        else
          color -> count
    }

    return bag.map(getMinimumsForRound(_))
  end getMinimumsForEachColorForRounds

  def getGamePower(string: String): Int =
    val getMinimumsForGame = (acc:Map[String, Int], curr:Map[String, Int]) => {
      val res = Map[String, Int](
        "red" -> 0, 
        "green" -> 0,
        "blue" -> 0
      )
      val accumulateMinimums: ((String, Int)) => (String, Int) = {
        case (color, count) =>
          if acc(color) < curr(color) then 
            color -> curr(color)
          else 
            color -> acc(color)
      }
      res.map(accumulateMinimums(_))
    }

    val rounds = string.split(": ").last.split(";")
    val minimumsMapping = rounds.map(getMinimumsForEachColorForRounds(_))
    val overallMinimums = minimumsMapping.reduceLeft(getMinimumsForGame)
    val gamePower = overallMinimums.values.reduce((a, b) => a * b)
    return gamePower
  end getGamePower

  val totalSum = data
    .linesIterator
    .map(getGamePower(_))
    .sum
  return totalSum
end day2p2