require 'elasticsearch/model'

class Recipe < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  # scope
  scope :published, ->{ where(published: true) }
  scope :unpublished, ->{ where(published: false) }
  ## Associations
  belongs_to :user
  has_many :steps, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :viewed_recipes, dependent: :destroy
  
  has_one_attached :image
  accepts_nested_attributes_for :ingredients, reject_if: ->(atts){ atts['name'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :steps, reject_if: :all_blank, allow_destroy: true

  ratyrate_rateable 'quality'
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

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :title, analyzer: 'english', index_options: 'offsets'
      indexes :ingredients do
        indexes :name, analyzer: 'english'
      end
    end
  end

  def as_indexed_json(options={})
    self.as_json(
      include: { ingredients: { only: :name}
              })
  end

  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ['title', 'ingredients.name']
          }
        }
      }
    )
  end
  ##
end

# Delete the previous articles index in Elasticsearch
Recipe.__elasticsearch__.client.indices.delete index: Recipe.index_name rescue nil

# Create the new index with the new mapping
Recipe.__elasticsearch__.client.indices.create \
  index: Recipe.index_name,
  body: { settings: Recipe.settings.to_hash, mappings: Recipe.mappings.to_hash }

# Index all Recipe records from the DB to Elasticsearch
Recipe.import