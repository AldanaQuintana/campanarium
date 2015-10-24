(function(){
  $("#no-more-results").hide();
  $("#search_users").on("input", function(e){
    $("#no-more-results").hide();
    $.ajax({
      url: "/users",
      method: "GET",
      data: {
        name_cont: $(e.target).val()
      }
    })
  })

})();