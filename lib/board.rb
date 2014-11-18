class Board

  attr_accessor :state, :current_player
  
    class Position
      attr_accessor :file, :rank

     def initialize(f, r)
       @file = f
       @rank = r
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

  end

  # check what is in 'from', if 'from' is not empty, do checks for validity of moving the given figure from 'from' to 'to' (split them into 12 cases)
  # if the validity test does not pass return false, else update the state (empty from and place the figure into to, do capture) and return the updated state
  def move(from, to)
	if valid_move? from, to
	  @state[to.file][to.rank] = @state[from.file][from.rank]
	  @state[from.file][from.rank] = 'EE'
	  if @current_player == 'W'
		@current_player = 'B'
	  else
		@current_player = 'W'
	  end
	  return true
	else
	  return false
	end
  end

  
  private
	def valid_move?(f, t)
	
  	mp = @state[f.file][f.rank] # piece to be moved
	  ds = @state[t.file][t.rank] # destination of the move
	  
	  # if the piece on f and the piece on t have the same
	  # color, the move is invalid
	  if mp[0] != @current_player or mp[0] == ds[0]
		return false
	  end
	  
	  case mp[1]
		when 'E' # no piece to move
	      return false
		  
		when 'P'
		  if mp[0] == 'B'
			factor = -1
			oc = 'W'
		  else
			factor = 1
			oc = 'B'
		  end
		  if f.file+factor == t.file
			if f.rank == t.rank and ds[0] == 'E'
			  return true
			elsif (f.rank-1 == t.rank or f.rank+1 == t.rank) and ds[0] == oc
			  return true
			else
			  return false
			end
		  elsif f.file+2*factor == t.file and f.rank == t.rank and ds[0] == 'E' and @state[f.file+factor][f.rank][0] == 'E'
			if f.file == 1 or f.file == 6
			  return true
			else
			  return false
			end
		  else
		    return false
		  end
		  
		when 'R'
		  if f.file != t.file and f.rank != t.rank
			return false
		  elsif f.file == t.file
		    return file_move f, t
		  else	# f.rank == t.rank
			return rank_move f, t
		  end
	  
		when 'N'
		  if f.rank-2 == t.rank or f.rank+2 == t.rank
			if (f.file-1 == t.file or f.file+1 == t.file) and ds[0] != mp[0]
			  return true
			else
			  return false
			end
		  elsif f.rank-1 == t.rank or f.rank+1 == t.rank
			if (f.file-2 == t.file or f.file+2 == t.file) and ds[0] != mp[0]
			  return true
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
		  elsif (f.file - t.file).abs != (f.rank - t.rank).abs
		    diag_move f, t
		  end
		when 'K'
	      if (f.file - t.file).abs > 1 or (f.rank - t.rank).abs > 1
		    return false
		  elsif mp[0] == ds[0]
		    return false
		  elsif is_check? t
		    return false
		  # CHECK FOR CASTLING HERE
		  else
			return true
		  end
		  
	  end
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
		  if @state[f.file][rank][0] != 'E'
		    return false
		  end
		end
		return true
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
		  if @state[file][f.rank][0] != 'E'
			return false
		  end
		end
		return true
	  end
	  
	  def diag_move(f, t)
	    df = (f.file - t.file).abs
	    if f.rank < t.rank
		  if f.file < t.file
		    for i in 1..(df-1)
			  if @state[f.file+i][f.rank+i][0] == @state[f.file][f.rank][0]
			    return false
			  end
			end
		  else
		    for i in 1..(df-1)
			  if @state[f.file-i][f.rank+i][0] == @state[f.file][f.rank][0]
			    return false
			  end
			end
		  end
		else
		  if f.file < t.file
		    for i in 1..(df-1)
			  if @state[f.file+i][f.rank-i][0] == @state[f.file][f.rank][0]
			    return false
			  end
			end
		  else
		    for i in 1..(df-1)
			  if @state[f.file-i][f.rank-i][0] == @state[f.file][f.rank][0]
			    return false
			  end
			end
		  end
		end
		return true
	  end

end