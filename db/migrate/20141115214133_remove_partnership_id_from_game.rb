class RemovePartnershipIdFromGame < ActiveRecord::Migration
  def change
    remove_column :games, :partnership_id, :integer
  end
end
