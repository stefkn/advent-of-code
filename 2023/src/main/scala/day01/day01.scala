package day01

def day1(data: String): Int =
  def getNumbers(string: String): Int =
    val fNum = string.find(_.isDigit).get
    val lNum = string.findLast(_.isDigit).get
    s"$fNum$lNum".toInt
  end getNumbers

  val totalSum = data
    .linesIterator
    .map(getNumbers(_))
    .sum

  return totalSum
end day1

