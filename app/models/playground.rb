class Playground < ApplicationRecord
  has_many :playground_categories, dependent: :destroy
  has_many :categories, through: :playground_categories
  has_many :post, dependent: :destroy
  
  def create_categories(input_categories)
    input_categories.each do |category| # splitで分けたcategoryをeach文で取得する
      new_category = Category.find_or_create_by(name: category) # categoryモデルに存在していれば、そのcategoryを使用し、なければ新規登録する
      categories << new_category unless categories.include?(new_category) # 登録するplaygroundのcategoryに紐づける（中間テーブルにも反映される）
    end
  end
end
