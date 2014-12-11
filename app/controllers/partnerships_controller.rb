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
    @partnership.user2_id = Integer(params[:user2_id])
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
    @partnership = Partnership.find_by id: Integer(params[:id])
    @partnership.confirmed = true
    game = @partnership.create_game(start: Time.now)
    new_board = Board.new
    initial_state = game.board_states.create(state: new_board.state, turn: new_board.current_player)
    initial_state.save
    respond_to do |format|
      if @partnership.save
        format.html { redirect_to users_current_games_path, notice: "You joined a new game!" }
        format.json { render :show, status: :created, location: @type }
      else
        format.html { render :new }
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end
  end

  def decline
    @partnership = Partnership.find_by id: Integer(params[:id])
    @partnership.confirmed = false
    respond_to do |format|
      if @partnership.save
        format.html { redirect_to users_invitations_url, notice: "You declined an invitation!" }
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
        format.html { redirect_to users_invitations_url, notice: 'The declined invitation was removed!' }
        format.json { head :no_content }
      end
    else
      redirect_to users_invitations_url, alert: 'The declined invitation could not be removed!'
    end
  end

  private
    def set_partnership
      @partnership = Partnership.find(Integer(params[:id]))
    end

    def partnership_params
      params.require(:partnership).permit(:user1_id, :user2_id, :game_id, :confirmed)
    end
end
