class BoardState < ActiveRecord::Base
  serialize :state, Array
  belongs_to :move
  belongs_to :game

  def json_state()
    state = self.state
    json_state = Hash.new
    json_state["white"] = []
    json_state["black"] = []
    state.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        if not cell == "EE"
          if cell[0] == "W"
            json_state["white"] << {"piece" => cell[1], "row" => r, "col" => c, "status" => "IN_PLAY"}
          elsif cell[0] = "B"
            json_state["black"] << {"piece" => cell[1], "row" => r, "col" => c, "status" => "IN_PLAY"}
          end
        end
      end
    end
    json_state
  end
end
