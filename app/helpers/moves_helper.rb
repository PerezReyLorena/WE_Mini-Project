module MovesHelper

  def display_move(move)
    if move.from_to
      player = User.find(move.user_id).username
      description = convert_move_to_description(move)
	  return "#{player}: #{description}"
	else
	  "No moves done yet."
	end
  end

  def convert_move_to_description(move)
    move_string = move.from_to
    from, to = move_string.split("->")
    r1 = from[1].to_i
    f1 = (from[3].to_i+96).chr
    r2 = to[1].to_i
    f2 = (to[3].to_i+96).chr
    return "#{f1}#{r1} -> #{f2}#{r2}"
  end


end
