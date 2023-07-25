class Post < ApplicationRecord
  has_one_attached :post_image
  
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
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image32.png')
      post_image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
    post_image.variant(resize_to_limit: [width, height]).processed
  end
  
  # 投稿いいねをしているか
  def favorited_by?(customer)
    post_favorites.exists?(customer_id: customer.id)
  end
  
  # 日別の投稿数を集計するスコープ
  scope :group_by_day_count, -> {
    min_created_at = Post.minimum(:created_at)
    exists = min_created_at.present?
    start_date = exists ? min_created_at.to_date : Date.today - 1.month
    end_date = Date.today
    counts = group("DATE(created_at)").count.transform_keys { |date| date.to_date }
    date_range = (start_date..end_date).to_a
    filled_counts = date_range.map { |date| [date, counts[date] || 0] }.to_h
    filled_counts
  }

  # 月別の投稿数を集計するスコープ
  scope :group_by_month_count, -> {
    min_created_at = Post.minimum(:created_at)
    exists = min_created_at.present?
    start_date = exists ? min_created_at.to_date.beginning_of_month : Date.today.beginning_of_month - 5.month
    end_date = Date.today.end_of_month
    counts = group("strftime('%Y-%m', created_at)").count
    date_range = (start_date..end_date).map { |date| date.strftime('%Y-%m') }
    filled_counts = date_range.map { |date| [date, counts[date] || 0] }.to_h
    filled_counts
  }

  
  # 並び替えメソッド
  scope :latest, -> { order(created_at: :desc) }  # 登録新しい順
  scope :old, -> { order(created_at: :asc) }      # 登録古い順
  scope :rate_high, -> { order(rate: :desc) } # 評価高い順
  scope :rate_low, -> { order(rate: :asc) }   # 評価低い順
  scope :likes_count_high, -> { left_joins(:post_favorites).group(:id).order(Arel.sql('COUNT(post_favorites.id) DESC')) } # いいねの数が多い順
  scope :likes_count_low, -> { left_joins(:post_favorites).group(:id).order(Arel.sql('COUNT(post_favorites.id) ASC')) }  # いいねの数が少ない順
  scope :comments_many, -> { left_joins(:post_comments).group(:id).order(Arel.sql('COUNT(post_comments.id) DESC')) }  # コメント多い順
  scope :comments_few, -> { left_joins(:post_comments).group(:id).order(Arel.sql('COUNT(post_comments.id) ASC')) }  # コメント少ない順
  
  PREFECTURES = [
    '北海道', '青森県', '岩手県', '宮城県', '秋田県', '山形県', '福島県',
    '茨城県', '栃木県', '群馬県', '埼玉県', '千葉県', '東京都', '神奈川県',
    '新潟県', '富山県', '石川県', '福井県', '山梨県', '長野県', '岐阜県',
    '静岡県', '愛知県', '三重県', '滋賀県', '京都府', '大阪府', '兵庫県',
    '奈良県', '和歌山県', '鳥取県', '島根県', '岡山県', '広島県', '山口県',
    '徳島県', '香川県', '愛媛県', '高知県', '福岡県', '佐賀県', '長崎県',
    '熊本県', '大分県', '宮崎県', '鹿児島県', '沖縄県'
  ]

  # ransack検索カラムのアソシエーション
  def self.ransackable_associations(auth_object = nil)
    ["customer", "image_attachment", "image_blob", "playground", "post_comments", "post_favorite_customers", "post_favorites", "post_tags", "post_target_ages", "tags", "target_ages"]
  end
  # ransackで検索するカラム
  def self.ransackable_attributes(auth_object = nil)
    ["text", "title", "created_at", "rate", "playtime"]
  end
end
