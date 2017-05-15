class AddLimitToUser < ActiveRecord::Migration
  def change
    add_column :users, :limit, :integer, :default => 5
  end
end
