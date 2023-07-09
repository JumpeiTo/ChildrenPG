class Post < ApplicationRecord
  has_one_attached :image
  
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  
  def get_item_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image32.png')
      image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

end
