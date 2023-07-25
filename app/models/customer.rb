class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy
  has_many :post_favorite_posts, through: :post_favorites, source: :customer

  validates :name, presence: true
  validates :nickname, presence: true
  validates :encrypted_password, presence: true

  has_one_attached :profile_image

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image32.png')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  # ゲストログイン用
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.name = 'ゲストユーザー'
      customer.nickname = 'ゲストユーザー'
      customer.is_hidden = true
    end
  end

  # is_deletedがfalseならtrueを返すようにしている
  def active_for_authentication?
    super && (is_deleted == false)
  end
  
  # 日別の登録数を集計するスコープ
  scope :group_by_day_count, -> {
    min_created_at = Customer.minimum(:created_at)
    exists = min_created_at.present?
    start_date = exists ? min_created_at.to_date : Date.today - 1.month
    end_date = Date.today
    counts = group("DATE(created_at)").count.transform_keys { |date| date.to_date }
    date_range = (start_date..end_date).to_a
    filled_counts = date_range.map { |date| [date, counts[date] || 0] }.to_h
    filled_counts
  }

  # 月別の登録数を集計するスコープ
  scope :group_by_month_count, -> {
    min_created_at = Customer.minimum(:created_at)
    exists = min_created_at.present?
    start_date = exists ? min_created_at.to_date.beginning_of_month : Date.today.beginning_of_month - 5.month
    end_date = Date.today.end_of_month
    counts = group("strftime('%Y-%m', created_at)").count
    date_range = (start_date..end_date).map { |date| date.strftime('%Y-%m') }
    filled_counts = date_range.map { |date| [date, counts[date] || 0] }.to_h
    filled_counts
  }

  
  # ransack検索カラムのアソシエーション
  def self.ransackable_associations(auth_object = nil)
    ["post_comments", "post_favorite_posts", "post_favorites", "posts"]
  end
  # ransack検索するカラム
  def self.ransackable_attributes(auth_object = nil)
    ["name", "nickname", "email", "created_at","is_hidden","is_deleted"]
  end
end
