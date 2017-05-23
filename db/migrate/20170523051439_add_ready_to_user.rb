class AddReadyToUser < ActiveRecord::Migration
  def change
    add_column :users, :ready, :boolean, :default => true
  end
end
