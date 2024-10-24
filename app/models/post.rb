class Post < ApplicationRecord
  validates :title, presence: true
  validates :photo, presence: true
  belongs_to :user
  has_many :likes, dependent: :destroy
  mount_uploader :photo, PostPhotoUploader
end
