class Post < ApplicationRecord
  validates :title, presence: true
  validates :photo, presence: true, on: :create
  validates :song_id, presence: true
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :reactions, dependent: :destroy
  mount_uploader :photo, PostPhotoUploader
  acts_as_taggable_on :tags

  def self.ransackable_attributes(_auth_object = nil)
    %w[title song_id song_name artist_name album_name]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user tags]
  end
end
