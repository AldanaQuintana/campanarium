(function(){
  if(!$("#notice_index").length != 0){ return; }
  var page = 1;

  $("#end-of-notices").bind("inview", function(event, isInView, visiblePartX, visiblePartY){
    if(isInView){
      page += 1;
      $.ajax({
        url: "/noticias",
        method: "GET",
        data: {
          page: page
        }
      }).then(function(data){
        console.log(data);
      });
    }
  })
})();