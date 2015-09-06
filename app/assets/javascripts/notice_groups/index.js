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

  var linkToClick = function(selector){
    $(selector).on("click", function(e){
      var $button = $(e.target).closest(selector);
      var $notice_panel = $button.closest(".notice-panel");
      $.ajax({
        url: $button.data("url"),
        method: $button.data("url-method") || "POST"
      }).then(function(){
        var $notice_group = $notice_panel.closest(".notice-group");
        if($notice_group.find(".notice-panel").not(".hidden").length == 1){
          $notice_group.addClass("hidden");
        }else{
          $notice_panel.addClass("hidden");
        }
      })
    })
  }

  linkToClick(".destroy-button");
  linkToClick(".unlink-button");
})();