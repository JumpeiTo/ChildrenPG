class TargetAge < ApplicationRecord
  
  has_many :post_target_ages, dependent: :destroy
  has_many :posts, through: :post_target_ages
  
end
