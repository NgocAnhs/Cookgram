ActiveAdmin.register Rate do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :rater_id, :rateable_type, :rateable_id, :stars, :dimension
  #
  # or
  #
  # permit_params do
  #   permitted = [:rater_id, :rateable_type, :rateable_id, :stars, :dimension]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
