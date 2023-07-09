class CreatePlaygrounds < ActiveRecord::Migration[6.1]
  def change
    create_table :playgrounds do |t|
      
      t.string :place_id, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :name, null: false
      t.text :overview
      t.string :icon
      t.string :postal_code
      t.string :address
      t.string :prefecture
      t.float :rate
      t.boolean :open_now
      t.text :business_hours
      t.string :website
      t.string :phone_number
      t.text :photo_urls
      t.text :category
      t.timestamps
    end
  end
end
