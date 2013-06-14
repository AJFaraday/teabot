#require File.dirname(__FILE__) + '/../lib/form_sender.rb'
require File.dirname(__FILE__) + '/../lib/helpers.rb'


# Collect data

loop do 
  # collect weight from totally real scale...
  weight = read_scale
  puts "Sending scale data: #{weight}"
  # send it to blind data-accepting method
  set_data({:weight => weight})
  
  sleep 10
end
