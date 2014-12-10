class Game < ActiveRecord::Base
  has_one :partnership
  belongs_to :user, :foreign_key => 'winner'
  has_many :moves
  has_many :board_states
  has_many :draw_requests

  def display_end_status(current_user)
    status = "The game is over!"
    if self.winner.present?
      winner = User.find(self.winner)
      winner == current_user ? status = status+" You won!" : status = status+" #{winner} won!"
    else
      status = status + " It's a draw!"
    end
    status
  end

end
