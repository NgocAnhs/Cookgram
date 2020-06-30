class AddPublishedToRecipe < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :published, :boolean, default: false
  end
end
