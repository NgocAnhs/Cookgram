class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.all.order("created_at desc")
  end

  def mark_as_read
    @notifications = current_user.notifications.unread
    @notifications.update_all(read: true)
    render json: {success: true}
  end
end
