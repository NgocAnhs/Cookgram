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
            return $("[data-behavior='unread-count']").text(0);
          }
        });
      };
  
      Notifications.prototype.handleSuccess = function(data) {
        var items;
        items = $.map(data, function(notification) {
          return `<a class='dropdown-item' href='${notification.url}'>${notification.actor} ${notification.action} your ${notification.notifiable_type}</a>`;
        });
        $("[data-behavior='unread-count']").text(items.length);
        return $("[data-behavior='notification-items']").html(items);
      };
  
      return Notifications;
  
    })();
  
    jQuery(function() {
      return new Notifications;
    });
  
  }).call(this);
})
