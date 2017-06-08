class AddAdtypeToAd < ActiveRecord::Migration[5.0]
  def change
    add_column :ads, :adtype, :string
  end
end
