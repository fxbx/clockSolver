#0 1 2 3 4 5 len = 6

def recalibrateIndex index, length
  if index < 0
    return length + index
  end
  if index >= length
    return index - length
  end
  return index
end

def moveHere input, index, tracer  
  tracer.push index
  if tracer.length == input.length #check for win
    return tracer
  end
  value = input[index].to_i
  input[index] = -1
  lefthand = recalibrateIndex(index + value, input.length)
  righthand = recalibrateIndex(index - value, input.length)
  if input[lefthand] == -1 && input[righthand] == -1 #check for loss
    return nil
  else
    if input[lefthand] != -1 
      catch = moveHere input.clone, lefthand, tracer.clone
      unless catch.nil?
        return catch
      end
    end
    if input[righthand] != -1 && lefthand != righthand #dont bother if theyre at the same place
      return moveHere input.clone, righthand, tracer.clone
    end
  end
  #INFERNO
  return nil
end

#presumes numbers were entered clockwise from some fixed point
def outputResultsVerbose tracer, input
  rotationTest = (tracer.length/2).to_i
  standingAt = -1
  (0..(tracer.length-1)).each do |posit|
    if standingAt == -1
      p "Start with the " + input[tracer[posit]] + " at position " + tracer[posit].to_s
      standingAt = tracer[posit]
    else
      dir = 1
      move = tracer[posit] - standingAt
      if move < 0
        move *= -1
	dir = -1
      end
      if move > rotationTest
	move = (tracer.length - move)
        dir *= -1
      end
      dirWords = (dir == 1 ? "clockwise" : "counterclockwise")
      p "Move " + move.to_s + " steps " + dirWords + " to the " + input[tracer[posit]] + " (position " + tracer[posit].to_s+ ")"
      standingAt = tracer[posit]
    end
  end
end

def outputResults tracer, input
  (0..(tracer.length-1)).each do |posit|
    p tracer[posit].to_s + " (" + input[tracer[posit]] + ")"
  end
end

def solveClock input
  tracer = Array.new
  (0..(input.length-1)).each do |posit|
    results = moveHere input.clone, posit, tracer
    unless results.nil?
      return results
    end
    tracer = Array.new
  end
  return nil
end

retValue = solveClock ARGV
unless retValue.nil?
  outputResults retValue, ARGV
  outputResultsVerbose retValue, ARGV
else
  p "Unsolvable?"
end
