class User < ActiveRecord::Base
  # Include default users modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :partnerships_as_player1, :class_name => 'Partnership', foreign_key: 'player1'
  has_many :partnerships_as_player2, :class_name => 'Partnership', foreign_key: 'player2'
end
