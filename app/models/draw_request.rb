class DrawRequest < ActiveRecord::Base
  belongs_to :game
  belongs_to :requester, :class_name => 'User', foreign_key: user_id
  belongs_to :requested, :class_name => 'User', foreing_key: user_id
end
