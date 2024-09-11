// For more information on writing tests, see
// https://scalameta.org/munit/docs/getting-started.html

import day03.*
import scala.io.Source

class Day3Suite extends munit.FunSuite {
  def getFile(filePath: String): String =
    val file = Source.fromFile(filePath)
    file.mkString
  end getFile
  test("Example test case") {
    val filename = "data/day03/example.txt"
    val data = getFile(filename)
    val expected = 4361
    val obtained = day3p1(data)
    assertEquals(obtained, expected)
  }
  test("Part 1") {
    val filename = "data/day03/day03.txt"
    val data = getFile(filename)
    val expected = 560670
    val obtained = day3p1(data)
    assertEquals(obtained, expected)
  }
  test("Example test case part 2") {
    val filename = "data/day03/example.txt"
    val data = getFile(filename)
    val expected = 467835
    val obtained = day3p2(data)
    assertEquals(obtained, expected)
  }
  // test("Part 2") {
  //   val filename = "data/day03/day03.txt"
  //   val data = getFile(filename)
  //   val expected = 78375
  //   val obtained = day3p2(data)
  //   assertEquals(obtained, expected)
  // }
}
