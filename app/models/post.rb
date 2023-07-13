class Post < ApplicationRecord
  has_one_attached :image
  
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :post_target_ages, dependent: :destroy
  has_many :target_ages, through: :post_target_ages
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
end
