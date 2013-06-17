function set_fill(percent) {
  //jQuery('#percent_display').html(percent);
  jQuery('#percent_display').removeClass('red');
  if (percent > 100) {
    jQuery('#percent_display').addClass('red');
    show_percent = 100
  }
  else if (percent < 0) {
    show_percent = 0
  }
  else {
    show_percent = percent
  }
  if (percent < 10) {
    jQuery('#percent_display').addClass('red');
  }
  var tea = jQuery('#tea');
  var height = 248.0;
  var offset = 110.0;

  var tea_height = (show_percent / 100.0) * height;
  var tea_top = ((height - tea_height + offset));

  //Plain non-animated method of setting height
  //tea.css('height',tea_height);
  //tea.css('top',tea_top);

  tea.animate({'height':tea_height, 'top':tea_top},{duration: 5000});
  jQuery({value:$('#percent_display').html()}).animate(
    {value:percent},
    {
      duration: 1000,
      step: function(){
        $('#percent_display').text(Math.round(this.value));
      }
    }
  );
}



function start_polling() {
  var $tide = setInterval(function () {
    jQuery.ajax({
      type: 'GET',
      cache: false,
      url: '/teapot_data',
      success: function(response){
        var data = JSON.parse(response);
        if (data.change){
          set_fill(data.percent_fill);
          jQuery('#teapot_name').html(data.teapot_name);
          jQuery('#cups_display').html(data.cups);
          jQuery('#cup_capacity').html(data.cup_capacity);
        }
        if (data.notify){
          jQuery('#teapot_summary').effect('highlight', {color:'#8b4513'}, 5000);
          flash_title();
        }
        jQuery('#pourer').html(data.current_pourer);
        jQuery('#tea_name').html(data.current_tea);
        jQuery('#time').html(data.last_made);
        jQuery('#poll_message').html(data.message);
      }
    })
  }, 60000);
}

function stop_polling(){
  window.clearInterval($tide);
}


function flash_title(){
  var notifyTitle = "Teabot(1) - Tea's up!"
  var usualTitle = "Teabot"
  var counter = 0
  var flashing = setInterval(function(){
    if (counter % 2 == 0)
    {
      jQuery('#head-title').html(notifyTitle);
    }
    else
    {
      jQuery('#head-title').html(usualTitle);
    }
    counter ++;
    if (counter >= 20) {
      clearInterval(flashing);
    };
  },500);
  jQuery('#head-title').html(usualTitle);
};



