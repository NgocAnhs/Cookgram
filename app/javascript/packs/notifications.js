$(document).on('turbolinks:load', function(){
  var notifications = $('[data-behavior="notifications"]')
  if (notifications.length) {
    console.log('haha')
  }
})
