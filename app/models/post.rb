class Post < ApplicationRecord
  validates :title, presence: true
  validates :photo, presence: true, on: :create
  validates :song_id, presence: true
  belongs_to :user
  has_many :likes, dependent: :destroy
  mount_uploader :photo, PostPhotoUploader
  acts_as_taggable_on :tags
end
