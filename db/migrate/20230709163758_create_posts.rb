class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      
      t.integer :customer_id, null: false
      t.integer :playground_id, null: false
      t.integer :tag_id, null: false
      t.string :title
      t.text :text
      t.integer :target_age, null: false, default: 0
      t.integer :playtime, null: false, default: 0
      t.integer :rate, null: false

      t.timestamps
    end
  end
end
