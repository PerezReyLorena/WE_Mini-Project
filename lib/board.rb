class Board

  attr_accessor :state, :current_player
  
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
  end

  # check what is in 'from', if 'from' is not empty, do checks for validity of moving the given figure from 'from' to 'to' (split them into 12 cases)
  # if the validity test does not pass return false, else update the state (empty from and place the figure into to, do capture) and return the updated state
  def move(from, to)
	if valid_move? from, to
	  @state[to.rank][to.file] = @state[from.rank][from.file]
	  @state[from.rank][from.file] = 'EE'
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
		  if mp[0] == 'B'
			factor = -1
			oc = 'W'
		  else
			factor = 1
			oc = 'B'
		  end
		  if f.rank+factor == t.rank
			if f.file == t.file and ds[0] == 'E'
			  return is_check?
			elsif (f.file-1 == t.file or f.file+1 == t.file) and ds[0] == oc
			  return is_check?
			else
			  return false
			end
		  elsif f.rank+2*factor == t.rank and f.file == t.file and ds[0] == 'E' and @state[f.rank+factor][f.file][0] == 'E'
			if f.rank == 1 or f.rank == 6
			  return is_check?
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
			  return is_check?
			else
			  return false
			end
		  elsif f.rank-1 == t.rank or f.rank+1 == t.rank
			if (f.file-2 == t.file or f.file+2 == t.file) and ds[0] != mp[0]
			  return is_check?
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
		  # CHECK FOR CASTLING HERE
		  else
			return is_check?
		  end
		  
	  end
	end
	
	# check if the king of current_player is in check
	def is_check?
	  r = @king_pos[@current_player].rank
	  f = @king_pos[@current_player].file
	  # set color of opponent
	  co = 'W'
	  if @current_player == 'W'
	    co = 'B'
	  end
	  
	  # check the inferior positions in the same file as the king
	  sr = r-1
	  sf = f
	  while @state[sr][sf] == 'EE' and sr>0
		sr = sr-1
	  end
	  p = @state[sr][sf]
	  if p[0] == oc and (p[1] == 'R' or p[1] == 'Q')
		return true
	  end
	  
	  # check the left-hand positions in the same rank as the king
	  sr = r
	  sf = f-1
	  while @state[sr][sf] == 'EE' and sf>0
		sf = sf-1
	  end
	  p = @state[sr][sf]
	  if p[0] == oc and (p[1] == 'R' or p[1] == 'Q')
		return true
	  end
	  
	  # check the right-hand positions in the same rank as the king
	  sr = r
	  sf = f+1
	  while @state[sr][sf] == 'EE' and sf<7
		sf = sf+1
	  end
	  p = @state[sr][sf]
	  if p[0] == oc and (p[1] == 'R' or p[1] == 'Q')
		return true
	  end
	  
	  # check the lower left positions on the kings first diagonal
	  sr = r-1
	  sf = f-1
	  while @state[sr][sf] == 'EE' and sr>0 and sf>0
		sr = sr-1
		sf = sf-1
	  end
	  p = @state[sr][sf]
	  if p[0] == oc and (p[1] == 'B' or p[1] == 'Q')
		return true
	  end
	  
	  # check the upper right positions on the kings first diagonal
	  sr = r+1
	  sf = f+1
	  while @state[sr][sf] == 'EE' and sr<7 and sf<7
		sr = sr+1
		sf = sf+1
	  end
	  p = @state[sr][sf]
	  if p[0] == oc and (p[1] == 'B' or p[1] == 'Q')
		return true
	  end
	  
	  # check the lower right positions on the kings second diagonal
	  sr = r-1
	  sf = f+1
	  while @state[sr][sf] == 'EE' and sr>0 and sf<7
		sr = sr-1
		sf = sf+1
	  end
	  p = @state[sr][sf]
	  if p[0] == oc and (p[1] == 'B' or p[1] == 'Q')
		return true
	  end
	  
	  # check the upper left positions on the kings second diagonal
	  sr = r+1
	  sf = f-1
	  while @state[sr][sf] == 'EE' and sr<7 and sf>0
		sr = sr+1
		sf = sf-1
	  end
	  p = @state[sr][sf]
	  if p[0] == oc and (p[1] == 'B' or p[1] == 'Q')
		return true
	  end
	  
	  # check if there is a knight that keeps the king in check
	  if (@state[r-2][f-1] == oc+'N') or (@state[r-2][f+1] == oc+'N')
		return true
	  elsif (@state[r+2][f-1] == oc+'N') or (@state[r+2][f+1] == oc+'N')
		return true
	  elsif (@state[r-1][f-2] == oc+'N') or (@state[r+1][f-2] == oc+'N')
		return true
	  elsif (@state[r-1][f+2] == oc+'N') or (@state[r+1][f+2] == oc+'N')
		return true
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
		  if @state[rank][f.file][0] != 'E'
		    return false
		  end
		end
		return is_check?
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
		return is_check?
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
		return true
	  end
	  
	  # test if the current player can move a piece
	  def can_move?
		for r in 0..7
		  for f in 0..7
			pos = Position.new(r,f)
		    piece = @state[i][j]
			if piece[0] == @current_player
			  if piece[1] == 'P'
				oc = 'W'
				factor = 1
			    if @current_player == 'W'
				  oc = 'B'
				  factor = -1
				end
				for k in -1..1
				  if valid_move(pos, Position.new(r+factor,f+k)) or valid_move(pos, Position.new(r+2*factor,f+k))
					return true
				  end 
				end
			  elsif piece[1] == 'R'
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
			  elsif piece[1] == 'N'
				# TODO check if Knight can move
			  elsif piece[1] == 'B'
				# TODO check if Bishop can move
			  elsif piece[1] == 'Q'
				# TODO check if Queen can move
			  elsif piece[1] == 'K'
				# TODO check if King can move
			  end
			end
		  end		  
		end
		return false
	  end

end