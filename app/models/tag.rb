class Tag < ApplicationRecord
  
  has_many :post_tags, dependent: :destroy
  has_many :post, through: :post_tags
  
  validates :name, presence: true
end
