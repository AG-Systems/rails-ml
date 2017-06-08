class AddAdstatusToAd < ActiveRecord::Migration[5.0]
  def change
    add_column :ads, :adstatus, :string
  end
end
