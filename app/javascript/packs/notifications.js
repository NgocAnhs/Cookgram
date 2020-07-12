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
          if (!notification.read) unread_count++;

          return `<a class='dropdown-item d-flex' href='${notification.url}'>
          <img alt="Qries" src="${notification.image_url}" class="square-small-img mr-2 my-auto">
          <div><strong>${notification.actor}</strong> ${notification.action} ${notification.notifiable_type.toLowerCase()}: <br/><i>${notification.content}</i> <br/>
          <small class="text-muted">${notification.created_at}</small></div></a>
          <hr style='margin:0'>`;
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
