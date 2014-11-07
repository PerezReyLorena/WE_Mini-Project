class AddMoveToBoardState < ActiveRecord::Migration
  def change
    add_column :board_states, :move_id, :integer
  end
end
