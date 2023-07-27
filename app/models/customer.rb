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
    
  # 日別の会員登録数を集計するスコープ
  scope :group_by_day_customer_count, -> {
    start_date = Date.today - 29.days # 過去30日間
    end_date = Date.today
    counts = group("DATE(created_at)").count.transform_keys { |date| date.to_date }
    date_range = (start_date..end_date).to_a
    filled_counts = date_range.map { |date| [date, counts[date] || 0] }.to_h
    filled_counts
  }

  # 月別の会員登録数を集計するスコープ
  scope :group_by_month_customer_count, -> {
    start_date = Date.today - 11.months # 過去12か月間
    end_date = Date.today
    if Rails.env == 'production'
      counts = group("DATE_FORMAT(created_at, '%Y-%m')").where(created_at: start_date..end_date).count
    else
      counts = group("strftime(created_at, '%Y-%m')").where(created_at: start_date..end_date).count
    end
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
