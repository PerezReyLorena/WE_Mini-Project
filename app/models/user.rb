class User < ActiveRecord::Base
  # Include default users modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :partnerships_as_user1, :class_name => 'Partnership', foreign_key: 'user1'
  has_many :partnerships_as_user2, :class_name => 'Partnership', foreign_key: 'user2'
  has_many :games
  has_many :moves
end
