var check_job_status_loop = function(board_button, job_id){
  setTimeout(function(){
    check_job_status(board_button, job_id)
  }, 2000);
};

var check_job_status = function(board_button, job_id){
  $.ajax({
    method: 'GET',
    url: '/job_status',
    data: { job_id: job_id }
  }).then(function(data){
    if(data.working == true){
      console.log("Job " + job_id + " still working")
      check_job_status_loop(board_button, job_id);
    }else{
      $.notify("La tarea ha finalizado correctamente.");
      board_button.find(".fa-plus-circle").removeClass("hidden");
      board_button.find(".fa-spinner").addClass("hidden");
    }
  })
};

$(".board-button").on("click", function(e){
  var data = {}
  var $board_button = $(e.target).closest(".board-button")
  var restore_button = function(){
    $board_button.find(".fa-plus-circle").removeClass("hidden");
    $board_button.find(".fa-spinner").addClass("hidden");
  };
  var url =  $board_button.data("url");
  if(url == "/load_notices"){
    data["hours"] = parseInt($board_button.closest(".panel").find("#hours").val() || 1)
  }
  $board_button.find(".fa-plus-circle").addClass("hidden");
  $board_button.find(".fa-spinner").removeClass("hidden");
  $.ajax({
    method: "POST",
    url: url,
    data: data
  }).then(function(data, status, message){
    console.log(arguments);
    var message = data.message || "";
    if(data.analyzer_status == "running" && data.task_status == null){
      window.wait_flash_response = true;
      $.notify("La tarea se está ejecutando, será notificado cuando termine. " + message, status);
      restore_button();
    }else{
      if(data.task_status == "ok"){
        $.notify("La tarea se ejecutó correctamente. " + message, status);
        if(data.job_id != undefined){
          check_job_status_loop($board_button, data.job_id);
        }
      }else{
        $.notify("No se pudo ejecutar la tarea. No hay datos suficientes.", status);
        restore_button();
      }
    }
  }).fail(function(data, status, message){
    console.log(arguments);
    $.notify("Hubo un problema ejecutando la tarea: " + message + ".\n Para más información vea el log del sistema.");
    restore_button();
  });
})