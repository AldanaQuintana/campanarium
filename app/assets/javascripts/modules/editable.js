(function(){
  if(!$(".editable").length > 0){ return; }

  var initializeEditables = function(container){
    var $container = container || $(document);
    var $editable_buttons_group = $container.find(".edit-group");

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
        var url_method = $button.data("url-method") || "POST";
        if($("#notice_index").length == 0 || (url_method === "DELETE" && confirm("¿Está seguro de que quiere eliminar la noticia? Esto no puede deshacerse."))){
          $.ajax({
            url: $button.data("url"),
            method: url_method
          }).then(function(){
            if(!$("#notice_index").length == 0){
              $editable.addClass("hidden");
              var $notice_group = $editable.closest(".notice-group");
              if($notice_group.find(".editable").not(".hidden").length == 0){
                $notice_group.addClass("hidden");
              }
            }else{
              $(".twits").trigger("msnry-element-removed", $editable);
            }
          })
        }
      })
    }

    linkToClick(".destroy-button");
    linkToClick(".unlink-button");
  }

  initializeEditables();

  $(document).on("editable-added", function(e){
    initializeEditables($(e.target));
  });
})();