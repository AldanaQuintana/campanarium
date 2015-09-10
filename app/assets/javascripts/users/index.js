(function(){
  $("#search_users").on("input", function(e){
    $.ajax({
      url: "/users",
      method: "GET",
      data: {
        name_cont: $(e.target).val()
      }
    }).then(function(data){
      console.log(arguments);
    })

  })

})();