$(".board-button").on("click", function(e){
  var url =  $(e.target).closest(".board-button").data("url")
  $.ajax({
    method: "POST",
    url: url
  }).then(function(data, status, message){
    console.log(arguments);
    var message = data.message || "";
    if(data.analyzer_status == "running" && data.task_status == null){
      window.wait_flash_response = true;
      $.notify("La tarea se está ejecutando, será notificado cuando termine. " + message, status);
    }else{
      if(data.task_status == "ok"){
        $.notify("La tarea se ejecutó correctamente. " + message, status);
      }else{
        $.notify("No se pudo ejecutar la tarea. No hay datos suficientes.", status);
      }
    }
  }).fail(function(data, status, message){
    console.log(arguments);
    $.notify("Hubo un problema ejecutando la tarea: " + message + ".\n Para más información vea el log del sistema.");
  });
})