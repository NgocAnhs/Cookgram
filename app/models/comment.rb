class Comment < ApplicationRecord
  ## Associations
  belongs_to :user
  belongs_to :recipe
  has_many :likes
  has_many_attached :comment_images

  ## Validates
  validates :content, presence: true
end
