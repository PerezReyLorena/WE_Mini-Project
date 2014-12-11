class MovesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_move, only: [:show, :edit, :update, :destroy, :validate]

  def new
    @move = Move.new
  end

  def index
    @moves = Move.where(game_id: Integer(params[:game_id]))
    @game = Game.find(Integer(params[:game_id]))
  end

  def create
    @move = Move.create(game_id: Integer(params[:game_id]), user_id: Integer(params[:user_id]))
    @move.from_to = params[:from_to]
    if @move.save
      redirect_to :action => :validate, id: @move.id
    end
  end

  def show
    @move = Move.find(Integer(params[:id]))
    @game = @move.game
    @state = BoardState.find_by_move_id(Integer(params[:id])).json_state()
  end

  def update
    respond_to do |format|
      if @move.update(move_params)
        format.html { redirect_to :action => :validate, id: @move.id}
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
    logger.debug "About to do a move…"
    #if the move is valid create a new BoardState entry and set valid to true
    logger.debug "The move is valid:"
    bla = board.move(from, to)
    if bla
      logger.debug "The move is valid:" + bla.to_s
      @move.valid = true
      @move.save
      game = Game.find(@move.game_id)
      next_state = game.board_states.create(state: board.state, turn: board.current_player, move_id: @move.id)
      next_state.save
      move_response = Hash.new
      move_response["last_move"] = "<li>#{@move.move_to_description()}</li>"
      logger.debug move_response["last_move"]
      # check if there are valid moves (+any other termination conditions) for the other player
      # if no valid moves: then you set the end of the game to Time.now and add the winner if needed
      # update the players score
      logger.debug "About to check for the termination..."
      finished = board.game_end?
      logger.debug "Game status from game_end() " + finished
      if not finished == "CONTINUE"
        game.end = Time.now
        partnership = Partnership.find_by_game_id(game.id)
        if not finished == 'DRAW'
          winner = (finished == 'B' ? partnership.user1_id : partnership.user2_id)
          game.winner = winner
          user = User.find(winner)
          user.score += 1
          user.save
        else
          player1 = User.find(partnership.user1_id)
          player1.score += 0.5
          player1.save
          player2 = User.find(partnership.user2_id)
          player2.score += 0.5
          player2.save
        end
        game.save
      end
      if not game.end.nil?
        logger.debug "About to set game_status: " + game.display_end_status(current_user)
        move_response["game_status"] = game.display_end_status(current_user)
      end
      render json: move_response
    else
      head :forbidden
    end

  end

  private
  def set_move
    @move = Move.find(Integer(params[:id]))
  end

  def move_params
    params.require(:move).permit(:user_id, :game_id, :valid, :from_to)
  end


end
