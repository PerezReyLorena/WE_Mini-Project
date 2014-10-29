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

  private
    def set_partnership
      @partnership = Partnership.find(params[:id])
    end

    def partnership_params
      params.require(:partnership).permit(:user1_id, :user2_id, :game_id)
    end
end
