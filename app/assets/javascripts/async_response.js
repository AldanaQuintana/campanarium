setInterval(function(){
  if(window.wait_flash_response){
    $.ajax({
      method: "GET",
      url: "/async_response"
    }).then(function(data){
      console.log(data.sentiments_status);
      console.log(data.semantic_status);
      if(data.sentiments_status != "running" && data.semantic_status != "running"){
        window.wait_flash_response = false
      }
      if(data.sentiments_status != null && data.sentiments_status != "running"){
        $.notify("El clasificador de comentarios ha finalizado.", data.sentiments_status == "finished" ? "success" : "error");
      }
      if(data.semantic_status != null && data.semantic_status != "running"){
        $.notify("El agrupador de noticias ha finalizado.", data.semantic_status == "finished" ? "success" : "error");
      }
    })
  }
}, 5000);