require File.dirname(__FILE__) + '/../lib/helpers.rb'


loop do
  set_data({:weight => read_scale},true)
  sleep 10
end
