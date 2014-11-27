class MoveParser
  # parses the move coordinates; takes a string and returns two pairs of indices
  # move_string should be of the following format: r1f1->r2f2
  # where f1 denotes the file and r1 denotes the rank of the tile of departure
  # and f2 and r2 denote the destination file and rank  
  def self.parse_move(move_string)
	from, to = move_string.split("->")
	r1 = from[1].to_i-1
	f1 = from[3].to_i-1
	r2 = to[1].to_i-1
	f2 = to[3].to_i-1
	return r1, f1, r2, f2
  end
end