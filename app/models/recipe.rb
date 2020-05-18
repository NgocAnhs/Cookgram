class Recipe < ApplicationRecord
  ## Associations
  belongs_to :user
  has_many :steps, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  
  has_one_attached :image
  accepts_nested_attributes_for :ingredients, reject_if: ->(atts){ atts['name'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :steps, reject_if: :all_blank, allow_destroy: true
  ##

  extend FriendlyId
  friendly_id :title, use: :slugged
  ## Validates
  validates :title, length: { in: 5..40 }
  validates_presence_of :ingredients, :steps
  validates_associated :ingredients, :steps
  ##

  ## Function
  def all_blank(atts)
    atts['content'].blank? && atts['step_images'].blank?
  end

  def is_liked(user)
    Like.find_by(user_id: user.id, recipe_id: id)
  end

  def is_bookmarked(user)
    Bookmark.find_by(user_id: user.id, recipe_id: id)
  end
  ##
end
