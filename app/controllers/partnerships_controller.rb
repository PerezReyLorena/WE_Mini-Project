class PartnershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_partnership, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @partnership = Partnership.new
  end


  # POST /types
  # POST /types.json

  def create
    @partnership = Partnership.new(partnership_params)
    @partnership.user1_id = current_user.id

    respond_to do |format|
      if @partnership.save
        format.html { redirect_to users_friends_path, notice: ' A new friend was successfully added.' }
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
