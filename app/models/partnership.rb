class Partnership < ActiveRecord::Base
  belongs_to :user1, :class_name => 'User'
  belongs_to :user2, :class_name => 'User'
  belongs_to :game, :class_name => 'Game'
end
