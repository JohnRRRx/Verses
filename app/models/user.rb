class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :reset_password_token, uniqueness: true, allow_nil: true
  mount_uploader :icon, IconUploader

  def own?(object)
    id == object&.user_id
  end

  def like(post)
    like_posts << post
  end

  def unlike(post)
    like_posts.destroy(post)
  end

  def like?(post)
    like_posts.include?(post)
  end
end
