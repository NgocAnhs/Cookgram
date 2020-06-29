ActiveAdmin.register Recipe do
  permit_params :user_id,
                :title,
                :image,
                ingredients_attributes: [:id, :name, :_destroy],
                steps_attributes: [:id, :content, {step_images: []}, :_destroy]
  
  controller do
    defaults :finder => :find_by_slug
  end
  
  filter :user
  filter :title
  filter :created_at

  index do
    selectable_column
    id_column
    column :user_id
    column :title
    column :image do |img|
      image_tag url_for(img.image), height: '50'
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :image do |img|
        image_tag url_for(img.image), height: '80'
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
