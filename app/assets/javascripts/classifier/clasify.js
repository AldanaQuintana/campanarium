(function(){
  if($(".classifier").length == 0 ){return;}

  var clasifier = new Classifier($("#notices_ids").data("ids"));
  var main_notice_id = null;
  var other_notice_id = null;
  var initialized = false;
  var related_ids = [];

  var noticePartial = function(data){
    return "<div class='notice-panel' data-id='" + data.id + "' ><h2>" + data.title + "</h2><div class='body'>" + data.body.substring(0, 200) + "(...)</div></div>";
  }

  var getMainRandomNotice = function(){
    clasifier.get_random_notice().then(function(data){
      main_notice_id = data.id;
      $("#main-notice")[0].innerHTML = noticePartial(data);
    })
  }

  getMainRandomNotice();

  var getRandomNotice = function(){
    clasifier.get_random_notice().then(function(data){
      other_notice_id = data.id;
      $("#other-notices")[0].innerHTML = noticePartial(data);
      if(!initialized){
        initialized = true;
        $("#other-notices").find(".notice-panel").on("click", function(e){
          var $panel = $(e.target).closest(".notice-panel");
          if($panel.hasClass("selected")){
            $panel.removeClass("selected");
            // sacar de related_ids
          }else{
            $panel.addClass("selected");
            related_ids.push($panel.data("id"));
          }
        });
      }
    })
  }

  getRandomNotice();

  $(".related_button").on("click", function(e){
    var $button = $(e.target);
    if(JSON.parse($button.data("related")) && related_ids.length > 0){
      clasifier.related(main_notice_id, related_ids);
    }
    getRandomNotice();
  });
})();