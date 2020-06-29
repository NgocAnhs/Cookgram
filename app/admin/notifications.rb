ActiveAdmin.register Notification do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :actor_id, :read, :action, :notifiable_id, :notifiable_type
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :actor_id, :read, :action, :notifiable_id, :notifiable_type]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
