class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.string :from_to
      t.boolean :valid

      t.timestamps
    end
  end
end
