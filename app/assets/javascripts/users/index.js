(function(){
  $("#search_users").on("input", function(e){
    $.ajax({
      url: "/users",
      method: "GET",
      data: {
        name_cont: $(e.target).val()
      }
    }).then(function(data){
      var $users_container = $("#users");
      var content = data.html_partial.length === 0 ? "No hay resultados" : data.html_partial;
      $users_container[0].innerHTML = content;
    })

  })

})();