class Move < ActiveRecord::Base
  belongs_to :game
  has_one :board_state
  belongs_to :user

  def move_to_description()
    move_string = self.from_to
    from, to = move_string.split("->")
    r1 = from[1].to_i+1
    f1 = (from[3].to_i+97).chr
    r2 = to[1].to_i+1
    f2 = (to[3].to_i+97).chr
    description = "#{f1}#{r1} → #{f2}#{r2}"
    player = User.find(self.user_id).username
    return "#{player}: #{description}"
  end

end
