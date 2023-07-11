class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :post, dependent: :destroy
         
  validates :name, presence: true
  validates :nickname, presence: true
  validates :encrypted_password, presence: true
end
