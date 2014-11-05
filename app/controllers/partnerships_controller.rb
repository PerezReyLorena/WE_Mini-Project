class PartnershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_partnership, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @partnership = Partnership.new
  end


  # POST /partnership
  # POST /partnership
  def create
    @partnership = Partnership.new
    @partnership.user1_id = current_user.id
    @partnership.confirmed = false
    @partnership.user2_id = params[:user2_id]
    friend_name = User.find(@partnership.user2_id).username
    respond_to do |format|
      if @partnership.save
        format.html { redirect_to users_friends_path, notice: " An invitation was sent to #{friend_name}!" }
        format.json { render :show, status: :created, location: @type }
      else
        format.html { render :new }
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end
  end

  def accept
    @partnership = Partnership.find_by id: params[:id]
    @partnership.confirmed = true
    @partnership.game = Game.new
    respond_to do |format|
      if @partnership.save
        format.html { redirect_to users_games_path, notice: "You joined a new game!" }
        format.json { render :show, status: :created, location: @type }
      else
        format.html { render :new }
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /partnership/1
  def destroy
    if @partnership.destroy
      respond_to do |format|
        format.html { redirect_to users_index_path, notice: 'You declined an invitation!' }
        format.json { head :no_content }
      end
    else
      redirect_to users_url, alert: 'You cannot decline an invitation!'
    end
  end

  private
    def set_partnership
      @partnership = Partnership.find(params[:id])
    end

    def partnership_params
      params.require(:partnership).permit(:user1_id, :user2_id, :game_id, :confirmed)
    end
end
