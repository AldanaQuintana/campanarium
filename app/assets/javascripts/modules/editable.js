(function(){
  if(!$(".editable").length > 0){ return; }

  var $editable_buttons_group = $(".edit-group");

  $editable_buttons_group.on("click", function(e){
    var $editable = $(e.target).closest(".editable");
    var $buttons = $(e.target).closest(".edit-group").find(".displayable").find(".button");
    $buttons.show();
    $editable.mouseleave(function(){
      $buttons.hide();
    })
  });

  var linkToClick = function(selector){
    $(selector).on("click", function(e){
      var $button = $(e.target).closest(selector);
      var $editable = $button.closest(".editable");
      $.ajax({
        url: $button.data("url"),
        method: $button.data("url-method") || "POST"
      }).then(function(){
        $editable.addClass("hidden");
        if(!$("#notice_index").length == 0){
          var $notice_group = $editable.closest(".notice-group");
          if($notice_group.find(".editable").not(".hidden").length == 0){
            $notice_group.addClass("hidden");
          }
        }
      })
    })
  }

  linkToClick(".destroy-button");
  linkToClick(".unlink-button");
})();