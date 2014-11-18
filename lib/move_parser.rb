class MoveParser
  # parses the move coordinates; takes a string and returns two pairs of indices
  # move_string should be of the following format: f1r1->f2r2
  # where f1 denotes the file and r1 denotes the rank of the tile of departure
  # and f2 and r2 denote the destination file and rank  
  def self.parse_move(move_string)
	from, to = move_string.split("->")
	f1 = from[1].to_i
	r1 = from[3].to_i
	f2 = to[1].to_i
	r2 = to[3].to_i
	return f1, r1, f2, r2
  end
end