class UsersController < ApplicationController
  before_action :authenticate_user!

  # GET users/index
  def index
    @users = User.where.not(id: current_user.id)
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

  # GET /users/invitations
  def invitations
    @received_invitations = Partnership.where('user2_id = ? AND confirmed IS NULL', current_user.id)
    @declined_invitations = Partnership.where('user1_id = ? AND confirmed = ?', current_user.id, false)
  end


  def current_games
    # get all partnerships of the current user
    partnerships = Partnership.where('(user1_id = ? OR user2_id = ?) AND confirmed = ?', current_user.id, current_user.id, true)
    # map them to the games
    game_ids = partnerships.map {|p| p.game_id}
    #@current_games = Game.where("id IN (#{game_ids.join(', ')}) AND end IS NULL")
    # for postgres include end into quotation marks
   @current_games = Game.where("id IN (#{game_ids.join(', ')}) AND "end" IS NULL")
  end


  def games_with_friend
    @partner = User.find(params[:user_id])
    partnerships = Partnership.where('(user1_id = ? AND user2_id = ?) AND confirmed = ?', current_user.id, params[:user_id], true)
    partnerships << Partnership.where('(user1_id = ? AND user2_id = ?) AND confirmed = ?', params[:user_id], current_user.id, true)
    game_ids = partnerships.last.map {|p| p.game_id}
    @games_with_friend = Game.find(game_ids)
  end

end
