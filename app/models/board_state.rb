class BoardState < ActiveRecord::Base
  serialize :state, Array
  belongs_to :move
  belongs_to :game
end
