(function(){
  if(!$(".editable").length > 0){ return; }

  var $modal = $("#destroy_user_modal").modal({show: false});
  $modal.on("hide.bs.modal", function(){
    $("#destroy_reasons").val("")
  });

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

    var callMethod = function($button, $editable, extra_data){
      var url_method = $button.data("url-method") || "POST";
      if($("#notice_index").length == 0 || url_method != "DELETE" || (url_method === "DELETE" && confirm("¿Está seguro de que quiere eliminar la noticia? Esto no puede deshacerse."))){
        $.ajax({
          url: $button.data("url"),
          method: url_method,
          data: $.extend({}, extra_data || {})
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
    }

    var linkToClick = function(selector, clickable){
      var $clickable = clickable || $(selector);
      $clickable.on("click", function(e){
        var $button = $(e.target).closest(selector);
        var $editable = $button.closest(".editable");
        if($editable.hasClass("user")){
          $modal.modal("show");
          $("#destroy_action").on("click", function(e){
            callMethod($button, $editable, {reasons: $("#destroy_reasons").val()});
            $modal.modal("hide");
            $editable.addClass("banned");
            $(e.target).unbind("click");
          });
        }else{
          callMethod($button, $editable)
        }
      })
    }

    linkToClick(".destroy-button", $container.find(".destroy-button"));
    linkToClick(".unlink-button", $container.find(".unlink-button"));
  }

  initializeEditables();

  $(document).on("editable-added", function(e){
    initializeEditables($(e.target));
  });
})();