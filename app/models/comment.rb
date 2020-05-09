class Comment < ApplicationRecord
  ## Associations
  belongs_to :user
  belongs_to :recipe
  has_many :likes
  has_many_attached :comment_images

  ## Validates
  validates :content, presence: true
  ##
  ## Function
  def is_liked(user)
    Like.find_by(user_id: user.id, comment_id: id)
  end
  ##
end
