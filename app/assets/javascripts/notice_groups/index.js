(function(){
  if(!$("#notice_index").length != 0){ return; }
  var page = 1;

  $("#end-of-notices").bind("inview", function(event, isInView, visiblePartX, visiblePartY){
    $(".fa.fa-spinner").removeClass("hidden");
    page += 1;
    $.ajax({
      url: "/noticias",
      method: "GET",
      data: {
        page: page
      }
    }).then(function(data){
      $(".fa.fa-spinner").addClass("hidden");
      var html_partial = _.reduce(data.groups, function(result, group){
        result += group.html_partial[0];
        return result;
      }, "");
      if(html_partial.length == 0){
        $("#no-more-results").show();
      }else{
        moreResults = true;
        $("#notice_index").append(html_partial);
      }
    });
  })
})();