class AddAttributeToPartnership < ActiveRecord::Migration
  def change
    add_column :partnerships, :confirmed, :boolean
  end
end
