class AddToReconToAd < ActiveRecord::Migration
  def change
    add_column :ads, :recon, :text
  end
end
