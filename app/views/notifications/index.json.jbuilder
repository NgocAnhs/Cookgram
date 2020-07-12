json.array! @notifications do |notification|
  json.id notification.id
  json.actor notification.actor.full_name
  json.action notification.action
  json.notifiable_type notification.notifiable_type
  json.read notification.read
  json.created_at notification.created_at.localtime.strftime("%Y-%m-%d %H:%M")

  if notification.notifiable_type == "Comment"
    json.image_url url_for(notification.notifiable&.recipe.image)
    json.content truncate(notification.notifiable&.content, length: 30)
    json.url recipe_path(notification.notifiable&.recipe)
  elsif notification.notifiable
    json.image_url url_for(notification.notifiable.image)
    json.content truncate(notification.notifiable&.title, length: 30)
    json.url recipe_path(notification.notifiable)
  end
end