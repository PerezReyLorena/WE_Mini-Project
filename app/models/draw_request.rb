class DrawRequest < ActiveRecord::Base
  belongs_to :game
  belongs_to :user, foreign_key: 'requester'
  belongs_to :user , foreign_key: 'requested'
end
