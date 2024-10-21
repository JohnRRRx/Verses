class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :photo, presence: true
  belongs_to :user
  mount_uploader :photo, PostPhotoUploader
end
