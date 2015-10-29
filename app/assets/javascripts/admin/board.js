$(".board-button").on("click", function(e){
  var url =  $(e.target).closest(".board-button").data("url")
  $.ajax({
    method: "POST",
    url: url
  }).then(function(data, status, message){
    console.log(arguments);
    if(data.analyzer_status == "running"){
      window.wait_flash_response = true;
      $.notify("La tarea se está ejecutando, será notificado cuando termine", status);
    }else{
      $.notify("No se pudo ejecutar la tarea. No hay datos suficientes.", status);
    }
  }).fail(function(data, status, message){
    console.log(arguments);
    $.notify("Hubo un problema ejecutando la tarea: " + message + ".\n Para más información vea el log del sistema.");
  });
})