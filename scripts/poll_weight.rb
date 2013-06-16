require File.dirname(__FILE__) + '/../lib/helpers.rb'


loop do
  get_data
  weight = read_scale
  if weight.to_f > (@data[:weight].to_f * 1.1)
    puts "Looks like the teapot's been filled again."
    set_data({:weight => weight, :last_filled => Time.now},true)
  else
    set_data({:weight => weight},true)
  end
  sleep 10
end
