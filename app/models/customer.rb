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

  # is_deletedがfalseならtrueを返すようにしている
  def active_for_authentication?
    super && (is_deleted == false)
  end
  
  # ransack検索カラムのアソシエーション
  def self.ransackable_associations(auth_object = nil)
    ["post_comments", "post_favorite_posts", "post_favorites", "posts"]
  end
  # ransack検索するカラム
  def self.ransackable_attributes(auth_object = nil)
    ["name", "nickname", "email", "created_at","is_hidden","is_deleted"]
  end
end
