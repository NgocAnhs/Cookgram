ActiveAdmin.register Recipe do
  permit_params :user_id,
                :title,
                :image,
                :published,
                ingredients_attributes: [:id, :name, :_destroy],
                steps_attributes: [:id, :content, {step_images: []}, :_destroy]
  
  scope :all
  scope :published
  scope :unpublished
  
  controller do
    defaults :finder => :find_by_slug
  end
  
  action_item :publish, only: :show do
    link_to "Publish", publish_admin_recipe_path(recipe), method: :put unless recipe.published
  end
  
  action_item :unpublish, only: :show do
    link_to "Unpublish", unpublish_admin_recipe_path(recipe), method: :put if recipe.published
  end

  member_action :publish, method: :put do
    recipe = Recipe.find_by_slug(params[:id])
    recipe.update(published: true)
    redirect_to admin_recipe_path(recipe)
  end

  member_action :unpublish, method: :put do
    recipe = Recipe.find_by_slug(params[:id])
    recipe.update(published: false)
    redirect_to admin_recipe_path(recipe)
  end

  filter :user
  filter :title
  filter :published
  filter :created_at

  index do
    selectable_column
    id_column
    column :published
    column :user_id
    column :title
    column :image do |img|
      image_tag url_for(img.image), height: '50' unless img.image.attachment.nil?
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :published
      row :image do |img|
        image_tag url_for(img.image), height: '80' unless img.image.attachment.nil?
      end
      panel "Ingredients" do
        table_for recipe.ingredients do
          column :name
        end
      end
      panel "Steps" do
        table_for recipe.steps do
          column :content
          column :step_images do |step|
            step.step_images.each do |img|
              span do 
                image_tag img, height: '70'
              end
            end
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Recipe Details' do
      f.input :user_id, as: :select, :collection => User.all
      f.input :title
      f.input :image, as: :file
      f.input :published, :label => "Publish"
    end
    f.inputs do
      f.has_many :ingredients, heading: 'Ingredient',
                               allow_destroy: true do |a|
        a.input :name
      end
    end
    f.inputs do
      f.has_many :steps, allow_destroy: true do |s|
        s.input :content
        s.input :step_images, as: :file, input_html: { multiple: true }
      end
    end
    f.actions
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :title, :user_id, :slug
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :user_id, :slug]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
