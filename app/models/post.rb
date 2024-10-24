class Post < ApplicationRecord
  validates :title, presence: true
  validates :photo, presence: true
  belongs_to :user
  mount_uploader :photo, PostPhotoUploader
end
