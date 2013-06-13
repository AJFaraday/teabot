require File.dirname(__FILE__) + '/../lib/form_sender.rb'

# Collect data

loop do 
  # collect weight from totally real scale...
  weight = ARGV[0]
  weight ||= (Time.now.min*-1)+60

  # send it to blind data-accepting method
  post({:weight => weight})
  
  sleep 60
end
