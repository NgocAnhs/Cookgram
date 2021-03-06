class RegistrationsController < Devise::RegistrationsController
  before_action :resource_params, only: :update_resource
  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    user_path(resource)
  end
  
  private

  def resource_params
    params(:user).permit(:fname, :lname, :birthday, :male)
  end
end
