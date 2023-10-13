class User < ApplicationRecord
  has_many :pictures
  has_many :favorites, dependent: :destroy
end
