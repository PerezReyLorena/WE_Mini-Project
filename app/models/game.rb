class Game < ActiveRecord::Base
  has_one :partnership
  belongs_to :user, :foreign_key => 'winner'
  has_many :moves
  has_many :board_states
end
