function set_fill(percent){
  var tea = jQuery('#tea');
  var height = 275.0;
  var offset = 95.0;

  var tea_height = (percent/100.0)*height;
  var tea_top = ((height-tea_height+offset));

  //tea.css('height',tea_height);
  //tea.css('top',tea_top);

  tea.animate({'height':tea_height,'top':tea_top},1000);
}

do
{
  setTimeout(function(){set_fill(100);set_fill(0)}, 1000);
}
while (1>0)