// For more information on writing tests, see
// https://scalameta.org/munit/docs/getting-started.html

import day01.*
import scala.io.Source

class Day1Suite extends munit.FunSuite {
  def getFile(filePath: String): String =
    val file = Source.fromFile(filePath)
    file.mkString
  end getFile
  test("Example test case") {
    val filename = "data/day01/example.txt"
    val data = getFile(filename)
    val expected = 142
    val obtained = day1(data)
    assertEquals(obtained, expected)
  }
  test("Part 1") {
    val filename = "data/day01/day01.txt"
    val data = getFile(filename)
    val expected = 54239
    val obtained = day1(data)
    assertEquals(obtained, expected)
  }
  test("Example test case 2") {
    val filename = "data/day01/example2.txt"
    val data = getFile(filename)
    val expected = 281
    val obtained = day1p2(data)
    assertEquals(obtained, expected)
  }
  test("Part 2") {
    val filename = "data/day01/day01.txt"
    val data = getFile(filename)
    val expected = 55343
    val obtained = day1p2(data)
    assertEquals(obtained, expected)
  }
}
