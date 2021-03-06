class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Pagy
  include Pagy::Backend

  def authenticate_active_admin_user!
    authenticate_user!
    unless current_user.admin?
      flash[:alert] = "Unauthorized Access!"
      redirect_to root_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fname, :lname, :birthday, :male, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:fname, :lname, :birthday, :male, :avatar, :password, :password_confirmation])
  end

  private
  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
    Rails.application.routes.default_url_options[:locale]= I18n.locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
