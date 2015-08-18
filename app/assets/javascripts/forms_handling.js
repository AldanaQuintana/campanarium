(function(){

  $(".ajax-form").submit(function(e){
    var spinner = $(e.target).find("i.fa.fa-spinner.fa-spin");
    spinner.removeClass('hide');
    $(e.target).find(".errors-container")[0].innerHTML = "";
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
    $(e.target).find(".errors-container")[0].innerHTML = errors.join("<br/>");
  });
})();