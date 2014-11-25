module MovesHelper

  def display_move(move)
    player = User.find(move.user_id).username
    description = convert_move_to_description(move)
    "#{player}: #{description}"
  end

  def convert_move_to_description(move)
    move_string = move.from_to
    from, to = move_string.split("->")
    f1 = from[1].to_i+1
    r1 = (from[3].to_i+97).chr
    f2 = to[1].to_i+1
    r2 = (to[3].to_i+97).chr
    return "#{r1}#{f1} -> #{r2}#{f2}"
  end


end
