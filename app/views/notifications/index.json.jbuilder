json.array! @notifications do |notification|
  json.id notification.id
  json.user notification.user.full_name
  json.action notification.action
  json.notifiable_type notification.notifiable_type
  json.url recipe_path(notification.notifiable.recipe)
end