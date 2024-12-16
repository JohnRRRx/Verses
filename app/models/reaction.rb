class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :emoji, presence: true
  validates :user_id, uniqueness: { scope: %i[post_id emoji] }

  broadcasts_to ->(reaction) { [reaction.post, 'reactions'] }, inserts_by: :prepend
end
