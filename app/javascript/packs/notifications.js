$(document).on('turbolinks:load', function(){
  (function() {
    var Notifications,
      __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  
    Notifications = (function() {
      function Notifications() {
        this.handleSuccess = __bind(this.handleSuccess, this);
        this.handleClick = __bind(this.handleClick, this);
        this.notifications = $("[data-behavior='notifications']");
        if (this.notifications.length > 0) {
          this.setup();
        }
      }
  
      Notifications.prototype.setup = function() {
        $("[data-behavior='notifications-link']").on("click", this.handleClick);
        return $.ajax({
          url: "/notifications.json",
          dataType: "JSON",
          method: "GET",
          success: this.handleSuccess
        });
      };
  
      Notifications.prototype.handleClick = function(e) {
        return $.ajax({
          url: "/notifications/mark_as_read",
          dataType: "JSON",
          method: "POST",
          success: function() {
            return $("[data-behavior='unread-count']").addClass('d-none');
          }
        });
      };
  
      Notifications.prototype.handleSuccess = function(data) {
        var items;
        var unread_count = 0;
        items = $.map(data, function(notification) {
          if (!notification.read)
            unread_count++;

          return `<a class='dropdown-item' href='${notification.url}'><strong>${notification.actor}</strong> ${notification.action} your ${notification.notifiable_type.toLowerCase()}: <i>${notification.content}</i></a><hr style='margin:0'>`;
        });
        if (unread_count > 0)
          $("[data-behavior='unread-count']").removeClass('d-none').text(unread_count);
        else
          $("[data-behavior='unread-count']").addClass('d-none');
        return $("[data-behavior='notification-items']").html(items);
      };
  
      return Notifications;
  
    })();
  
    jQuery(function() {
      return new Notifications;
    });
  
  }).call(this);
})
