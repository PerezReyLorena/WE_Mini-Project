class Board

  attr_accessor :state, :current_player

  # @@MIN = 0
  # @@MAX = 7

  class Position
    attr_accessor :rank, :file

    def initialize(r, f)
      @rank = r
      @file = f
    end

  end

  # creates a new board with the initial game configuration if no params
  # creates a board from the passed state otherwise
  def initialize(params = {})
    # creates an two dimensional 8 by 8 array and sets all cells to 'EE' (not occupied)
    # @state = Array.new(8) { Array.new(8, 'EE') }

    # set the initial status of a chess game
    @state = params[:state] || [['WR', 'WN', 'WB', 'WQ', 'WK', 'WB', 'WN', 'WR'],
                                ['WP', 'WP', 'WP', 'WP', 'WP', 'WP', 'WP', 'WP'],
                                ['EE', 'EE', 'EE', 'EE', 'EE', 'EE', 'EE', 'EE'],
                                ['EE', 'EE', 'EE', 'EE', 'EE', 'EE', 'EE', 'EE'],
                                ['EE', 'EE', 'EE', 'EE', 'EE', 'EE', 'EE', 'EE'],
                                ['EE', 'EE', 'EE', 'EE', 'EE', 'EE', 'EE', 'EE'],
                                ['BP', 'BP', 'BP', 'BP', 'BP', 'BP', 'BP', 'BP'],
                                ['BR', 'BN', 'BB', 'BQ', 'BK', 'BB', 'BN', 'BR']]
    # set current player to white ('W' = white, 'B' = black)
    @current_player = params[:current_player] || 'W'
    @king_pos = {'W' => Position.new(0,4), 'B' => Position.new(7,4) }
    for i in 0..7
      for j in 0..7
        if @state[i][j][1] == 'K'
          @king_pos[@state[i][j][0]] = Position.new(i, j)
        end
      end
    end
  end

  # check what is in 'from', if 'from' is not empty, do checks for validity of moving the given figure from 'from' to 'to' (split them into 12 cases)
  # if the validity test does not pass return false, else update the state (empty from and place the figure into to, do capture) and return the updated state
  def move(from, to)
    if valid_move? from, to
      @state[to.rank][to.file] = @state[from.rank][from.file]
      @state[from.rank][from.file] = 'EE'
      # if king has been moved update @king_pos variable
      if @state[to.rank][to.file][1] == 'K'
        @king_pos[@current_player] = Position.new(to.rank, to.file)
      end
      @current_player = (@current_player == 'W' ? 'B' : 'W')
      return true
    elsif castle? from, to
      @state[to.rank][to.file] = @state[from.rank][from.file]
      @state[from.rank][from.file] = 'EE'
      if to.file > from.file # right castling
        @state[from.rank][7] = 'EE'
        @state[from.rank][5] = @current_player+'R'
      else # left castling
        @state[from.rank][0] = 'EE'
        @state[from.rank][3] = @current_player+'R'
      end

      @king_pos[@current_player] = Position.new(to.rank, to.file)
      @current_player = (@current_player == 'W' ? 'B' : 'W')
      return true
    else
      return false
    end
  end


  # private
  def valid_move?(f, t)
    if f.rank<0 or f.rank>7 or f.file<0 or f.file>7 or t.rank<0 or t.rank>7 or t.file<0 or t.file>7
      return false
    end

    mp = @state[f.rank][f.file] # piece to be moved
    ds = @state[t.rank][t.file] # destination of the move

    # if the piece on f and the piece on t have the same
    # color, the move is invalid
    if mp[0] != @current_player or mp[0] == ds[0]
      return false
    end

    case mp[1]
      when 'E' # no piece to move
        return false

      when 'P'
        factor = (mp[0] == 'B' ? -1 : 1)
        oc = (mp[0] == 'B' ? 'W' : 'B')
        # if mp[0] == 'B'
        # factor = -1
        # oc = 'W'
        # else
        # factor = 1
        # oc = 'B'
        # end
        if f.rank+factor == t.rank
          if f.file == t.file and ds[0] == 'E'
            return is_not_check? f, t
          elsif (f.file-1 == t.file or f.file+1 == t.file) and ds[0] == oc
            return is_not_check? f, t
          else
            return false
          end
        elsif f.rank+2*factor == t.rank and f.file == t.file and ds[0] == 'E' and @state[f.rank+factor][f.file][0] == 'E'
          if f.rank == 1 or f.rank == 6
            return is_not_check? f, t
          else
            return false
          end
        else
          return false
        end

      when 'R'
        if f.rank != t.rank and f.file != t.file
          return false
        elsif f.rank == t.rank
          return rank_move f, t
        else	# f.file == t.file
          return file_move f, t
        end

      when 'N'
        if f.rank-2 == t.rank or f.rank+2 == t.rank
          if (f.file-1 == t.file or f.file+1 == t.file) and ds[0] != mp[0]
            return is_not_check? f, t
          else
            return false
          end
        elsif f.rank-1 == t.rank or f.rank+1 == t.rank
          if (f.file-2 == t.file or f.file+2 == t.file) and ds[0] != mp[0]
            return is_not_check? f, t
          else
            return false
          end
        end

      when 'B'
        if (f.file - t.file).abs != (f.rank - t.rank).abs
          return false
        else
          return diag_move f, t
        end

      when 'Q'
        if f.file == t.file
          return file_move f, t
        elsif f.rank == t.rank
          return rank_move f, t
        elsif (f.file - t.file).abs == (f.rank - t.rank).abs
          diag_move f, t
        end
      when 'K'
        if (f.file - t.file).abs > 1 or (f.rank - t.rank).abs > 1
          return false
        elsif mp[0] == ds[0]
          return false
        else
          return is_not_check? f, t
        end
    end
  end

  # check if the king of current_player is in check
  # if from and to are provided this method controls
  # if the move from -> to would lead to a check position
  def is_not_check?(from=nil, to=nil)
    r = @king_pos[@current_player].rank
    f = @king_pos[@current_player].file
    new_state = Marshal.load(Marshal.dump(@state))
    Rails.logger.debug "Current state:"
    Rails.logger.debug @state.to_s
    if from!=nil and to!=nil
      Rails.logger.debug "Moving #{from.to_s} to #{to.to_s} (from #{@state[from.rank][from.file]} to #{@state[to.rank][to.file]})"
    end
    if from!=nil and to!=nil and @state[to.rank][to.file][0] != @state[from.rank][from.file][0]
      new_state[to.rank][to.file] = @state[from.rank][from.file]
      new_state[from.rank][from.file] = 'EE'
      Rails.logger.debug "Future state:"
      Rails.logger.debug new_state.to_s
      if @state[from.rank][from.file][1] == 'K'
        r = to.rank
        f = to.file
      end
    end
    # set color of opponent
    oc = (@current_player == 'W' ? 'B' : 'W')

    # check if king is kept in check by a pawn
    factor = (@current_player == 'W' ? 1 : -1)
    if new_state[r+factor][f-1] == oc+'P' or new_state[r+factor][f+1] == oc+'P'
      return false
    end
    Rails.logger.debug "No pawns are checking the king!"

    # check the inferior positions in the same file as the king
    sr = r
    sf = f
    while sr>0 # and new_state[sr][sf][0] != @current_player
      sr = sr-1
      p = new_state[sr][sf]
      if p[0] == oc and (p[1] == 'R' or p[1] == 'Q')
        Rails.logger.debug "The king is checked from below by: #{p[1]}"
        return false
      elsif p[0] == @current_player
        break
      end
    end
    Rails.logger.debug "Nothing checks the king from below!"

    # check the superior positions in the same file as the king
    sr = r
    sf = f
    while sr<7 # and new_state[sr][sf][0] != @current_player
      sr = sr+1
      Rails.logger.debug "  checking above the king at #{sr}"
      p = new_state[sr][sf]
      if p[0] == oc and (p[1] == 'R' or p[1] == 'Q')
        Rails.logger.debug "  king is checked from #{sr}"
        return false
      elsif p[0] == @current_player
        Rails.logger.debug "  king is protected from #{sr}"
        break
      end
    end
    Rails.logger.debug "Nothing checks the  king from above!"

    # check the left-hand positions in the same rank as the king
    sr = r
    sf = f
    while sf>0 # and new_state[sr][sf][0] != @current_player
      sf = sf-1
      p = new_state[sr][sf]
      if p[0] == oc and (p[1] == 'R' or p[1] == 'Q')
        return false
      elsif p[0] == @current_player
        break
      end
    end
    Rails.logger.debug "Nothing checks the  king from left!"

    # check the right-hand positions in the same rank as the king
    sr = r
    sf = f
    while sf<7 # and new_state[sr][sf][0] != @current_player
      sf = sf+1
      p = new_state[sr][sf]
      if p[0] == oc and (p[1] == 'R' or p[1] == 'Q')
        return false
      elsif p[0] == @current_player
        break
      end
    end
    Rails.logger.debug "Nothing checks the  king from right!"

    # check the lower left positions on the kings first diagonal
    sr = r
    sf = f
    while sr>0 and sf>0 # and new_state[sr][sf][0] != @current_player
      sr = sr-1
      sf = sf-1
      p = new_state[sr][sf]
      if p[0] == oc and (p[1] == 'B' or p[1] == 'Q')
        return false
      elsif p[0] == @current_player
        break
      end
    end
    Rails.logger.debug "Nothing checks the  king from lower left!"

    # check the upper right positions on the kings first diagonal
    sr = r
    sf = f
    while sr<7 and sf<7 # and new_state[sr][sf][0] != @current_player
      sr = sr+1
      sf = sf+1
      p = new_state[sr][sf]
      if p[0] == oc and (p[1] == 'B' or p[1] == 'Q')
        return false
      elsif p[0] == @current_player
        break
      end
    end
    Rails.logger.debug "Nothing checks the king from upper right!"

    # check the lower right positions on the kings second diagonal
    sr = r
    sf = f
    while sr>0 and sf<7 # and new_state[sr][sf][0] != @current_player
      sr = sr-1
      sf = sf+1
      p = new_state[sr][sf]
      if p[0] == oc and (p[1] == 'B' or p[1] == 'Q')
        return false
      elsif p[0] == @current_player
        break
      end
    end
    Rails.logger.debug "Nothing checks the  king from lower right!"

    # check the upper left positions on the kings second diagonal
    sr = r
    sf = f
    while sr<7 and sf>0 # and new_state[sr][sf][0] != @current_player
      sr = sr+1
      sf = sf-1
      p = new_state[sr][sf]
      if p[0] == oc and (p[1] == 'B' or p[1] == 'Q')
        return false
      elsif p[0] == @current_player
        break
      end
    end
    Rails.logger.debug "Nothing checks the  king from upper left!"

    # check if there is a knight that keeps the king in check
    if r>0+1 and f>0 and (new_state[r-2][f-1] == oc+'N')
      Rails.logger.debug "Knight 1"
      return false
    elsif r>0+1 and f<7 and (new_state[r-2][f+1] == oc+'N')
      Rails.logger.debug "Knight 2"
      return false
    elsif r<7-1 and f>0 and (new_state[r+2][f-1] == oc+'N')
      Rails.logger.debug "Knight 3"
      return false
    elsif r<7-1 and f<7 and (new_state[r+2][f+1] == oc+'N')
      Rails.logger.debug "Knight 4"
      return false
    elsif r>0 and f>0+1 and (new_state[r-1][f-2] == oc+'N')
      Rails.logger.debug "Knight 5"
      return false
    elsif r<7 and f>0+1 and (new_state[r+1][f-2] == oc+'N')
      Rails.logger.debug "Knight 6"
      return false
    elsif r>0 and f<7-1 and (new_state[r-1][f+2] == oc+'N')
      Rails.logger.debug "Knight 7"
      return false
    elsif r<7 and f<7-1 and (new_state[r+1][f+2] == oc+'N')
      Rails.logger.debug "Knight 8"
      return false
    end
    Rails.logger.debug "No knight is checking the  king!"

    return true
  end

  def file_move(f, t)
    start = f.rank
    stop  = t.rank
    if f.rank > t.rank
      start = t.rank
      stop  = f.rank
    end

    start = start+1
    stop = stop-1
    for rank in start..stop
      if @state[rank][f.file][0] != 'E'
        return false
      end
    end
    return is_not_check? f, t
  end

  def rank_move(f, t)
    start = f.file
    stop  = t.file
    if f.file > t.file
      start = t.file
      stop  = f.file
    end

    start = start+1
    stop = stop-1
    for file in start..stop
      if @state[f.rank][file][0] != 'E'
        return false
      end
    end
    return is_not_check? f, t
  end

  def diag_move(f, t)
    df = (f.file - t.file).abs
    if f.rank < t.rank
      if f.file < t.file
        for i in 1..(df-1)
          if @state[f.rank+i][f.file+i][0] == @state[f.rank][f.file][0]
            return false
          end
        end
      else
        for i in 1..(df-1)
          if @state[f.rank+i][f.file-i][0] == @state[f.rank][f.file][0]
            return false
          end
        end
      end
    else
      if f.file < t.file
        for i in 1..(df-1)
          if @state[f.rank-i][f.file+i][0] == @state[f.rank][f.file][0]
            return false
          end
        end
      else
        for i in 1..(df-1)
          if @state[f.rank-i][f.file-i][0] == @state[f.rank][f.file][0]
            return false
          end
        end
      end
    end
    return is_not_check? f,t
  end

  # test if the current player can move a piece
  def can_move?
    for r in 0..7
      for f in 0..7
        pos = Position.new(r,f)
        piece = @state[r][f]
        if piece[0] == @current_player
          if piece[1] == 'P'
            oc = (@current_player == 'B' ? 'W' : 'B')
            factor = (@current_player == 'B' ? -1 : 1)
            for k in -1..1
              if valid_move?(pos, Position.new(r+factor,f+k))
                return true
              end
            end
            if valid_move?(pos, Position.new(r+2*factor,f))
              return true
            end
          elsif piece[1] == 'R' or piece[1] == 'B' or piece[1] == 'Q'
            if piece[1] == 'R' or piece[1] == 'Q'
              for k in 0..r-1
                if file_move(pos, Position.new(k, f))
                  return true
                end
              end
              for k in r+1..7
                if file_move(pos, Position.new(k, f))
                  return true
                end
              end
              for k in 0..f-1
                if rank_move(pos, Position.new(r, k))
                  return true
                end
              end
              for k in f+1..7
                if rank_move(pos, Position.new(r, k))
                  return true
                end
              end
            end
            if piece[1] == 'B' or piece[1] == 'Q'
              nr = r
              nf = f
              while nr>0 and nf>0
                nr = nr-1
                nf = nf-1
                if diag_move(pos, Position.new(nr, nf))
                  return true
                end
              end
              nr = r
              nf = f
              while nr<7 and nf<7
                nr = nr+1
                nf = nf+1
                if diag_move(pos, Position.new(nr, nf))
                  return true
                end
              end
              nr = r
              nf = f
              while nr>0 and nf<7
                nr = nr-1
                nf = nf+1
                if diag_move(pos, Position.new(nr, nf))
                  return true
                end
              end
              nr = r
              nf = f
              while nr<7 and nf>0
                nr = nr+1
                nf = nf-1
                if diag_move(pos, Position.new(nr, nf))
                  return true
                end
              end
            end
          elsif piece[1] == 'N'
            if valid_move?(pos, Position.new(r-1,f-2))
              return true
            elsif valid_move?(pos, Position.new(r-1,f+2))
              return true
            elsif valid_move?(pos, Position.new(r-2,f-1))
              return true
            elsif valid_move?(pos, Position.new(r-2,f+1))
              return true
            elsif valid_move?(pos, Position.new(r+1,f-2))
              return true
            elsif valid_move?(pos, Position.new(r+1,f+2))
              return true
            elsif valid_move?(pos, Position.new(r+2,f-1))
              return true
            elsif valid_move?(pos, Position.new(r+2,f+1))
              return true
            end
          elsif piece[1] == 'K'
            if valid_move?(pos, Position.new(r-1,f-1))
              return true
            elsif valid_move?(pos, Position.new(r-1,f))
              return true
            elsif valid_move?(pos, Position.new(r-1,f+1))
              return true
            elsif valid_move?(pos, Position.new(r,f-1))
              return true
            elsif valid_move?(pos, Position.new(r,f+1))
              return true
            elsif valid_move?(pos, Position.new(r+1,f-1))
              return true
            elsif valid_move?(pos, Position.new(r+1,f))
              return true
            elsif valid_move?(pos, Position.new(r+1,f+1))
              return true
            end
            if castle? pos, Position.new(pos.rank, 2) or castle? pos, Position.new(pos.rank, 6)
              return true
            end
          end
        end
      end
    end
    return false
  end

  # Check if the king can castle in the indicated direction. Check if the move
  # from position 'from' to position 'to' is a legal castling
  def castle?(from, to)
    r = (@current_player == 'W' ? 0 : 7)
    c = @current_player
    rp = (to.file < from.file ? 0 : 7)
    if from.rank != r or from.file != 4 or @state[r][rp] != c+'R'
      return false
    else
      if to.file < from.file
        return (is_not_check?(Position.new(r, 3)) and is_not_check?(Position.new(r, 2)))
      else
        return (is_not_check?(Position.new(r, 5)) and is_not_check?(Position.new(r, 6)))
      end
    end
  end

  def game_end?
    if self.can_move? == false
      if self.is_not_check?
        return "DRAW"
      else
        winner = (self.current_player == 'B' ? "W" : "B")
        return winner
      end
    else
      return "CONTINUE"
    end
  end
end