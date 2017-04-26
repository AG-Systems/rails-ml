class AddAuthorToAd < ActiveRecord::Migration
  def change
    add_column :ads, :author, :text
  end
end
