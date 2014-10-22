class CreatePartnerships < ActiveRecord::Migration
  def change
    create_table :partnerships do |t|
      t.integer :user1_id
      t.integer :user2_id
      t.integer :game_id

      t.timestamps
    end
  end
end
