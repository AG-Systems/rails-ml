class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :title
      t.string :feedback
      t.string :rating
      t.string :image

      t.timestamps null: false
    end
  end
end
