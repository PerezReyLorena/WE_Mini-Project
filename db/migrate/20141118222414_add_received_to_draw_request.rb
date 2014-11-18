class AddReceivedToDrawRequest < ActiveRecord::Migration
  def change
    add_column :draw_requests, :received, :boolean
  end
end
