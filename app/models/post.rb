class Post < ApplicationRecord
  has_one_attached :image
  
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :post_target_ages, dependent: :destroy
  has_many :target_ages, through: :post_target_ages
  has_many :post_comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy
  has_many :post_favorite_customers, through: :post_favorites, source: :customer
  belongs_to :customer
  belongs_to :playground
  
  validates :rate, presence: true
  
  enum playtime_method: { 'oneday': 0, '2hours': 1, '4hours': 2, '6hours': 3, '8hours': 4 }
  
  def get_post_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image32.png')
      image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end
  
  # 投稿いいねをしているか
  def favorited_by?(customer)
    post_favorites.exists?(customer_id: customer.id)
  end
  
   # 日別の投稿数を集計するスコープ
  scope :group_by_day_count, -> { group("DATE(created_at)").count.transform_keys { |date| date.to_date } }

  # 月別の投稿数を集計するスコープ
  scope :group_by_month_count, -> { group("strftime('%Y-%m', created_at)").count }
  
  # ransack検索カラムのアソシエーション
  def self.ransackable_associations(auth_object = nil)
    ["customer", "image_attachment", "image_blob", "playground", "post_comments", "post_favorite_customers", "post_favorites", "post_tags", "post_target_ages", "tags", "target_ages"]
  end
  # ransack検索するカラム
  def self.ransackable_attributes(auth_object = nil)
    ["text", "title", "created_at"]
  end
  
end
