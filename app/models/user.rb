class User < ApplicationRecord
  has_many :pictures
  has_many :favorites, dependent: :destroy

  before_validation { email.downcase!}
  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 255},
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  has_secure_password
  validates :password, length: {minimum: 6}

  mount_uploader :avatar, AvatarUploader
end
