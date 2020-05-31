class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.not_read.all.order("created_at desc")
  end

  def mark_as_seen
    @notifications = current_user.notifications.not_read
    @notifications.update_all(seen: true)
    render json: {success: true}
  end
end
