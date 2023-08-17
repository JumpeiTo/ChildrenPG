class CreatePlaygroundCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :playground_categories do |t|
      t.references :playground, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
