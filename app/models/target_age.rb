class TargetAge < ApplicationRecord
  
  has_many :post_target_ages, dependent: :destroy
  has_many :posts, through: :post_target_ages
  
  # ransackで検索するカラム
  def self.ransackable_attributes(auth_object = nil)
    ["age"]
  end
  
end
