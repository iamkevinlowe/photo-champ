$(function() {
  initPage();
});

$(window).bind('page:change', function() {
  initPage();
});

function initPage() {
  $('#challenge_challenger_id').change(function() {
    var src = $(this).val();
    $('.challenge-preview').html(
      "<%= image_tag(@challenger_photos.where(id: " + $(this).val() + ").first.url.challenge, class: 'img-rounded img-responsive') %>");
  });
}