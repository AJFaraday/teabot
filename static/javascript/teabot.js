function set_fill(percent){
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