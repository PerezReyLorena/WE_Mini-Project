class AddTurnToBoardState < ActiveRecord::Migration
  def change
    add_column :board_states, :turn, :string
  end
end
