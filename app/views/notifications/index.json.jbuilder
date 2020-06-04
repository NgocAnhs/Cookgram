json.array! @notifications do |notification|
  json.id notification.id
  json.actor notification.actor.full_name
  json.action notification.action
  json.notifiable_type notification.notifiable_type
  json.read notification.read

  if notification.notifiable_type == "Comment"
    json.content truncate(notification.notifiable.content, length: 15)
    json.url recipe_path(notification.notifiable.recipe)
  else
    json.content truncate(notification.notifiable.title, length: 15)
    json.url recipe_path(notification.notifiable, anchor: "comments")
  end
end