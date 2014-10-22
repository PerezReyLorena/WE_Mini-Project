class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :partnership_id
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end
end
