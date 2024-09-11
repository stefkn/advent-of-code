package day03 

def day3p1(data: String): Int =
  def createPartNumberListFromMapping(
    schematicData: Array[Array[Char]]
  ): List[Int] = {
    val directions = List(
      (1, 0), (-1, 0), (0, -1), (0, 1),  // UP DOWN LEFT RIGHT
      (1, -1), (1, 1), (-1, -1), (-1, 1)  // UP-L UP-R DOWN-L DOWN-R
    )
    var temp = ""
    var adjacent = false
    var result: List[Int] = List()

    for {
      row <- 0 until schematicData.length
      col <- 0 until schematicData(row).length
    } {
      val current = schematicData(row)(col)

      if (current.isDigit)
        // check adjacency 
        for 
          (rOffset, cOffset) <- directions 
        do 
          val newRow = row + rOffset
          val newCol = col + cOffset
          if (
            newRow >= 0 
            && newRow < schematicData.length 
            && newCol >= 0 
            && newCol < schematicData(newRow).length 
            && Set(
              '*', '+', '$', '#', '=', '@', '/', '%', '-', '&'
            ).contains(schematicData(newRow)(newCol))  
          ) {
            adjacent = true
          } 
        // Number continues, append new Int to temp buffer 
        temp :+= current
      else 
        // End of number. Empty the buffer
        if (temp.length() > 0)
          val temptoint = temp.toInt
          if (adjacent) {
            // print(s"$temptoint ")
            result = result.appended(temp.toInt)
          } else {
            // print(s"X$temptoint ")
          }
        temp = ""
        adjacent = false
    }
    // println(result)
    return result
  }

  val schematicDataArray = data.linesIterator.map(_.toCharArray).toArray
  val partNumbers = createPartNumberListFromMapping(schematicDataArray)
  return partNumbers.sum
end day3p1

