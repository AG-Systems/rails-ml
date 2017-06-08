class AddAdcolorToAd < ActiveRecord::Migration[5.0]
  def change
    add_column :ads, :adcolor, :string
  end
end
