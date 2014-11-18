class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  respond_to :html

  # list all games of the current user
  def index
    partnerships = Partnership.where('user1_id = ? OR user2_id = ?', current_user.id, current_user.id)
    game_ids = partnerships.map {|p| p.game_id}
    @games = Game.find(game_ids)
  end

  def show
    @game = Game.find(params[:id])
    # select the latest board state
    board_state =  BoardState.where(game_id: @game.id).order("created_at").last
    @state = board_state.state
    @turn = board_state.turn
    @moves = Move.where(game_id: @game.id)
  end

  def new
    @game = Game.new
  end

  # TODO: validate the move and create a new board state
  def move

  end

  def edit
  end

  def create
    @game = Game.new(game_params)
    @game.save
  end


  def destroy
    @game.destroy
    respond_with(@game)
  end

  private
    def set_game
      @game = Game.find(params[:id])
    end

    def game_params
      params.require(:game).permit(:partnership_id, :start, :end)
    end
end
