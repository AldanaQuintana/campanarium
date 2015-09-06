(function(){
  if(!$("#notice_index").length > 0){ return; }

  var $edit_notice = $(".edit-notice");

  $edit_notice.on("click", function(e){
    var $notice_panel = $(e.target).closest(".notice-panel");
    var $buttons = $(e.target).closest(".edit-notice").find(".displayable").find(".button");
    $buttons.show();
    $notice_panel.mouseleave(function(){
      $buttons.hide();
    })
  });

  var callMethod = function($button, $notice_panel){
    $.ajax({
      url: $button.data("url"),
      method: $button.data("url-method") || "POST"
    }).then(function(){
      $notice_panel.hide();
    })
  }

  $(".destroy-button").on("click", function(e){
    var $button = $(e.target).closest(".destroy-button");
    var $notice_panel = $button.closest(".notice-panel");
    callMethod($button, $notice_panel);
  });

  $(".unlink-button").on("click", function(e){
    var $button = $(e.target).closest(".unlink-button");
    var $notice_panel = $button.closest(".notice-panel");
    callMethod($button, $notice_panel);
  })
})();