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
    }).then(function(data){
      var $users_container = $("#users");
      if(!(data.html_partial.length === 0)){
        $users_container[0].innerHTML = data.html_partial;
        $users_container.trigger("editable-added");
      }else{
        $users_container[0].innerHTML = "";
        $("#no-more-results").show();
      }
    })

  })

})();