(function(){

  $(".ajax-form").submit(function(e){
    var spinner = $(e.target).find("i.fa.fa-spinner.fa-spin");
    spinner.removeClass('hide');
    $(e.target).find(".errors-container")[0].innerHTML = "";
    $(e.target).find(".has-error").each(function(index, field_with_error){
      $(field_with_error).removeClass("has-error");
    })
  });

  $(".ajax-form").on("ajax:success", function(e, data, status, xhr){
    var spinner = $(e.target).find("i.fa.fa-spinner.fa-spin");
    spinner.addClass('hide');
    window.location.replace(data.url);
  });

  $(".ajax-form").on("ajax:error", function(e, data, status, xhr){
    var spinner = $(e.target).find("i.fa.fa-spinner.fa-spin");
    spinner.addClass('hide');
    var errors = data.responseJSON.errors;
    var fields_with_errors = data.responseJSON.fields_with_errors;
    $.each(fields_with_errors, function(index, field_with_error){
      var field = $(e.target).find("." + field_with_error + "_field" );
      field.addClass("has-error");
    })
    $(e.target).find(".errors-container")[0].innerHTML = errors.join("<br/>");
  });
})();