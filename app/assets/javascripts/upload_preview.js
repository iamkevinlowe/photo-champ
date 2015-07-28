$(function() {
  initPage();
});

$(window).bind('page:change', function() {
  initPage();
});

function initPage() {
  var preview = $(".upload-preview img");
  
  $("#photo_url").change(function(event){
     var input = $(event.currentTarget);
     var file = input[0].files[0];
     var reader = new FileReader();
     reader.onload = function(e){
         image_base64 = e.target.result;
         preview.attr("src", image_base64);
     };
     reader.readAsDataURL(file);
  });
}