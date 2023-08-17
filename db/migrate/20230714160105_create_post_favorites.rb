class CreatePostFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :post_favorites do |t|
      t.references :customer, foreign_key: true
      t.references :post, foreign_key: true
      t.timestamps

      # 重複登録を防ぐための記述
      t.index [:customer_id, :post_id], unique: true
    end
  end
end
