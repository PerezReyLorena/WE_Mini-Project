class ChangeInttoFloatForScores < ActiveRecord::Migration
  def change
    change_column :users, :score, :float
  end
end
