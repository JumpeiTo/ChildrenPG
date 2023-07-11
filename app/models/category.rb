class Category < ApplicationRecord
  has_many :playground_categories, dependent: :destroy
  has_many :playgrounds, through: :playground_categories
end
