# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, presence: true
  validates :photo, presence: { message: 'を選択してください' }, on: :create
  validates :song_id, presence: { message: 'を選択してください' }
  belongs_to :user
  has_many :likes, dependent: :destroy
  mount_uploader :photo, PostPhotoUploader
  acts_as_taggable_on :tags
end
