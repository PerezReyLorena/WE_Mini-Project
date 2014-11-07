class Move < ActiveRecord::Base
  belongs_to :game
  has_one :board_state
  belongs_to :user
end
