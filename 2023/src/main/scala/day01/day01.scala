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

def day1p2(data: String): Int =
  val stringIntMap = collection.mutable.Map[String, Int](
    "one" -> 1,
    "two" -> 2,
    "three" -> 3,
    "four" -> 4,
    "five" -> 5,
    "six" -> 6,
    "seven" -> 7,
    "eight" -> 8,
    "nine" -> 9,
  )
  val reversedStrIntMap = stringIntMap map {
    case (key, value) => (key.reverse, value)
  }

  def getLeftSideNum(string: String, mapping: collection.mutable.Map[String, Int]): Int =
    var temp = ""

    for c <- string do
      if c.isDigit then return c.asDigit

      temp :+= c

      for numstr <- mapping.keys do
        if temp contains numstr then 
          return mapping(numstr)

    return 0
  end getLeftSideNum

  def getNumbers(string: String): Int =
    val fNum = getLeftSideNum(string, stringIntMap)
    val lNum = getLeftSideNum(string.reverse, reversedStrIntMap)
    val res = s"$fNum$lNum".toInt
    // println(s"$string => $res")
    return res
  end getNumbers

  val totalSum = data
    .linesIterator
    .map(getNumbers(_))
    .sum

  return totalSum
end day1p2
