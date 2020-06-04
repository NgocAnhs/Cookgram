import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    $(document).on('turbolinks:load', this.binding());
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    // var item = `<a class='dropdown-item' href='${notification.url}'>${notification.actor} ${notification.action} your ${notification.notifiable_type}</a>`
    // $("[data-behavior='notification-items']").html(data["notification"]);
    // if (data["unread_count"] > 0)
    //   $("[data-behavior='unread-count']").removeClass('d-none').text(data["unread_count"]);
    // else
    //   $("[data-behavior='unread-count']").addClass('d-none');
    this.binding()
  },

  binding() {
    $("[data-behavior='notifications-link']").on("click", this.handleClick);
    return $.ajax({
      url: "/notifications.json",
      dataType: "JSON",
      method: "GET",
      success: this.handleSuccess
    });
  },

  handleClick() {
    return $.ajax({
      url: "/notifications/mark_as_read",
      dataType: "JSON",
      method: "POST",
      success: function() {
        return $("[data-behavior='unread-count']").addClass('d-none');
      }
    });
  },

  handleSuccess(data) {
    var items;
    var unread_count = 0;
    items = $.map(data, function(notification) {
      if (!notification.read)
        unread_count++;
      return `<a class='dropdown-item' href='${notification.url}'><strong>${notification.actor}</strong> ${notification.action} your ${notification.notifiable_type.toLowerCase()}: <i>"${notification.content}"</i></a><hr style='margin:0'>`;
    });
    if (unread_count > 0)
      $("[data-behavior='unread-count']").removeClass('d-none').text(unread_count);
    else
      $("[data-behavior='unread-count']").addClass('d-none');
    return $("[data-behavior='notification-items']").html(items);
  }
});
