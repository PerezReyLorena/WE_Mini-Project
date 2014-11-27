class MovesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_move, only: [:show, :edit, :update, :destroy, :validate]

  def new
    @move = Move.new
  end

  def create
    @move = Move.create(game_id: params[:game_id], user_id: params[:user_id])
    respond_to do |format|
      if @move.save
        format.html { render :edit}
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @move.update(move_params)
       format.html { redirect_to :action => :validate, id: @move.id}
       # format.html { redirect_to game_url(id: @move.game_id) }
      else
        format.html { render :edit }
      end
    end
  end

  def validate
    #Parse the from_to field
    parsed_move =  MoveParser.parse_move(@move.from_to)
    from = Board::Position.new(parsed_move[0], parsed_move[1])
    to = Board::Position.new(parsed_move[2], parsed_move[3])

    #get the latest board state and use it to initialize a Board object
    current_board = BoardState.where(game_id: @move.game_id).order("created_at").last
    board = Board.new state: current_board.state, current_player: current_board.turn
    #if the move is valid create a new BoardState entry and set valid to true

    respond_to do |format|
      if board.move(from, to)
        @move.valid = true
        game = Game.find(@move.game_id)
        next_state = game.board_states.create(state: board.state, turn: board.current_player)
        next_state.save
        format.html { redirect_to game_url(id: @move.game_id), notice: "Your move is valid!"}
        # format.html { redirect_to game_url(id: @move.game_id) }
      else
        format.html {redirect_to game_url(id: @move.game_id), notice: "Your move is invalid!"}
      end
    end

  end

  private
  def set_move
    @move = Move.find(params[:id])
  end

  def move_params
    params.require(:move).permit(:user_id, :game_id, :valid, :from_to)
  end

end
