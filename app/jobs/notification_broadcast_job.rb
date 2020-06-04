class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(notification)
    # Do something later
    # html = ApplicationController.render partial: "notifications/notifications", locals: {notification: notification, unread_count: unread_count}, formats: [:html]
    ActionCable.server.broadcast("notifications:#{notification.user.id}", notification: notification)
  end
end
