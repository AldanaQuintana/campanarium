var Classifier = function(notice_ids){
  this.not_classified = notice_ids;
  this.classified = [];
}

Classifier.prototype.get_notice = function(id){
  return new Promise(function(fulfill, reject){
    $.ajax({
      url: "notices/" + id + ".json"
    }).done(function(data){
      fulfill(data);
    })
  })
}

Classifier.prototype.get_random_notice = function(){
  return this.get_notice(this.not_classified.sample());
}

Classifier.prototype.related = function(main_id, related_id){
  return new Promise(function(fulfill, reject){
    $.ajax({
      url: "related",
      method: "POST",
      data: {
        main: main_id,
        related: related_id
      }
    }).done(function(data){
      fulfill(data);
    })
  });
}