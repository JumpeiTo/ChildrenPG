class PostTargetAge < ApplicationRecord
  belongs_to :post
  belongs_to :target_age

  # ransack検索カラムのアソシエーション
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "post_id", "target_age_id", "updated_at"]
  end
end
