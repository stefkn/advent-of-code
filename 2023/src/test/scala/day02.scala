// For more information on writing tests, see
// https://scalameta.org/munit/docs/getting-started.html

import day02.*
import scala.io.Source

class Day2Suite extends munit.FunSuite {
  def getFile(filePath: String): String =
    val file = Source.fromFile(filePath)
    file.mkString
  end getFile
  test("Example test case") {
    val filename = "data/day02/example.txt"
    val data = getFile(filename)
    val expected = 8
    val obtained = day2p1(data)
    assertEquals(obtained, expected)
  }
  test("Part 1") {
    val filename = "data/day02/day02.txt"
    val data = getFile(filename)
    val expected = 2406
    val obtained = day2p1(data)
    assertEquals(obtained, expected)
  }
  test("Example test case part 2") {
    val filename = "data/day02/example.txt"
    val data = getFile(filename)
    val expected = 2286
    val obtained = day2p2(data)
    assertEquals(obtained, expected)
  }
  test("Part 2") {
    val filename = "data/day02/day02.txt"
    val data = getFile(filename)
    val expected = 78375
    val obtained = day2p2(data)
    assertEquals(obtained, expected)
  }
}
