class Board

  attr_accessor :state

  # creates a new board with the initial game configuration if no params
  # creates a board from the passes state otherwise
  def initialize(params = [])
    # creates an two dimensional 8 by 8 array and sets all cells to 0
    @state = Array.new(8) { Array.new(8, 0) }


  end

  # check what is in 'from', if 'from' is not empty, do checks for validity of moving the given figure from 'from' to 'to' (split them into 12 cases)
  # if the validity test does not pass return false, else update the state (empty from and place the figure into to, do capture) and return the updated state
  def move(from, to)

  end


end