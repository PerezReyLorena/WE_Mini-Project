class User < ActiveRecord::Base

  before_validation(on: :create) do
    self.score = 0
  end
  mount_uploader :image, ImageUploader
  # Include default users modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :partnerships_as_user1, :class_name => 'Partnership', foreign_key: 'user1_id', dependent: :destroy
  has_many :partnerships_as_user2, :class_name => 'Partnership', foreign_key: 'user2_id', dependent: :destroy
  has_many :games, :class_name => 'Game', foreign_key: 'winner', dependent: :destroy
  has_many :moves, dependent: :destroy


  def nb_games
    Partnership.where('user1_id = ? OR user2_id = ?', self, self).count
  end

end
