class PostComment < ApplicationRecord
  
  belongs_to :customer
  belongs_to :post
  
  validates :comment, presence: true
  
  # ransack検索カラムのアソシエーション
  def self.ransackable_associations(auth_object = nil)
    ["customer", "post"]
  end
  
  # ransack検索するカラム
  def self.ransackable_attributes(auth_object = nil)
    ["comment", "created_at", "post_id"]
  end
  
end
