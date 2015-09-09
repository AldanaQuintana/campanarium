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
        var html_partial = _.reduce(data.groups, function(result, group){
          result += group.html_partial[0];
          return result;
        }, "");
        $("#end-of-notices")[0].innerHTML += html_partial;
      });
    }
  })
})();