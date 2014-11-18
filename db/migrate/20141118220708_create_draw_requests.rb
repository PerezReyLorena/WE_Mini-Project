class CreateDrawRequests < ActiveRecord::Migration
  def change
    create_table :draw_requests do |t|
      t.integer :game_id
      t.integer :requester
      t.integer :requested

      t.timestamps
    end
  end
end
