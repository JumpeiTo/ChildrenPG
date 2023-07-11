class CreatePostTargetAges < ActiveRecord::Migration[6.1]
  def change
    create_table :post_target_ages do |t|
      
      t.references :post, foreign_key: true
      t.references :target_age, foreign_key: true

      t.timestamps
    end
  end
end
