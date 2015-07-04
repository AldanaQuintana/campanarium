$(window).on('mercury:ready', function(){
  Mercury.on('saved', function(event, data){
    window.open(data.url);
  })
})