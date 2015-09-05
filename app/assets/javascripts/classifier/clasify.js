(function(){
  if($(".classifier").length == 0 ){return;}

  var clasifier = new Classifier($("#notices_ids").data("ids"));
  var main_notice_id = null;
  var other_notice_id = null;

  var getMainRandomNotice = function(){
    clasifier.get_random_notice().then(function(data){
      main_notice_id = data.id;
      $("#main-notice").text(data.title + " - " + data.body);
    })
  }

  getMainRandomNotice();

  var getRandomNotice = function(){
    clasifier.get_random_notice().then(function(data){
      other_notice_id = data.id;
      $("#other-notice").text(data.title + " - " + data.body);
    })
  }

  getRandomNotice();

  $(".related_button").on("click", function(e){
    var $button = $(e.target);
    if(JSON.parse($button.data("related"))){
      clasifier.related(main_notice_id, other_notice_id);
    }
    getRandomNotice();
  });
})();