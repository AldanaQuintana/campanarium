(function(){
  if($("#edit_user").length === 0){ return; }

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $('#avatar_preview').attr('src', e.target.result);
      }

      reader.readAsDataURL(input.files[0]);
    }
  }

  $("#avatar_input").change(function(){
      readURL(this);
  });
})();