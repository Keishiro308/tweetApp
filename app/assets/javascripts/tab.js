
$(document).on("ready turbolinks:load", function() {
  $(".tab_container div").on('click', function(){
    $('div.active_tab').removeClass('active_tab')
    let containerToShow = $(this).attr('rel')
    $(this).addClass('active_tab')
    $('.content.active').slideUp(0, function(){
      $(this).removeClass('active')
      $('#'+containerToShow).slideDown(0, function(){
        $(this).addClass('active')
      });
    });
  });
});
