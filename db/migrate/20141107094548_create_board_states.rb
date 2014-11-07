class CreateBoardStates < ActiveRecord::Migration
  def change
    create_table :board_states do |t|
      t.integer :game_id
      t.text :state

      t.timestamps
    end
  end
end
