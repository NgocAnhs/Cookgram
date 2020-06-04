class Notification < ApplicationRecord
  after_commit -> { NotificationBroadcastJob.perform_later(self) }

  belongs_to :user
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }
end
