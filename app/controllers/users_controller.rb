class UsersController < ApplicationController
  before_action :authenticate_user!

  # GET users/index
  def index
  end

  # GET /users/friends
  def friends
    #get all partnerships of the current user
    partnerships = Partnership.where('user1_id = ? OR user2_id = ?', current_user.id, current_user.id)
    #remove duplicates, i.e. all partnerships with the same pairs of users
    already_found_friends = Hash.new
    @friends = Array.new
    partnerships.each do |p|
      p.user1_id == current_user.id ? f = p.user2_id : f = p.user1_id
      unless already_found_friends[f] == true then
        already_found_friends[f] = true
        @friends << p
      end
    end
  end

end
