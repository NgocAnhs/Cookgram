class Step < ApplicationRecord
  ## Associations
  belongs_to :recipe
  has_many_attached :step_images
end
