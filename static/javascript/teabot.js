function set_fill(percent){
  if (percent > 100)
  {
    percent = 100 ;
  }
  if (percent < 0)
  {
    percent = 0 ;
  }
  var tea = jQuery('#tea');
  var height = 275.0;
  var offset = 95.0;

  var tea_height = (percent/100.0)*height;
  var tea_top = ((height-tea_height+offset));

  //Plain non-animated method of setting height
  //tea.css('height',tea_height);
  //tea.css('top',tea_top);

  tea.animate({'height':tea_height,'top':tea_top},1000);
  jQuery('#percent_display').html(percent);
}

function start_polling(){
    var $tide = setInterval(function(){
        set_fill(90);
        set_fill(20)
    },10000);
}

