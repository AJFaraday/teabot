# Classic detection algorithm
#
# Weight has increased 10% from the last positive weight and is between 80 and 110 percent

require 'rubygems'
require File.dirname(__FILE__) + '/../lib/helpers.rb'
require 'csv'


def classic_detection(reading)
  if ((reading.to_f > (@data[:last_positive_weight].to_f * 1.1)) and
    reading > 80 and reading < 110 #and
                                   #reading.to_f == @data[:weight].to_f
  )
    puts "Looks like the teapot's been filled again."
    set_data({:weight => reading.to_f, :last_filled => Time.now}, true)

    @detected = 'FILL DETECTED'

  else
    set_data({:weight => reading.to_f}, true)

    @detected = ''

  end

  if reading > 0
    set_data({:last_positive_weight => reading}, true)
  end

  File.open(@output_file, 'a') do |out|
    output = [reading, get_status(reading), @detected]
    puts output.inspect
    out.puts CSV.generate_line(output)
  end
end

def smoothing(reading, window1,window2,window3)

  window1 << reading
  window1.shift if window1.length > 2
  sum = 0.0
  window1.each{|x|sum += x.to_f}
  smoothed_reading1 = sum/window1.length

  window2 << reading
  window2.shift if window2.length > 5
  sum = 0.0
  window2.each{|x|sum += x.to_f}
  smoothed_reading2 = sum/window2.length

  window3 << reading
  window3.shift if window3.length > 20
  sum = 0.0
  window3.each{|x|sum += x.to_f}
  smoothed_reading3 = sum/window3.length
  

  File.open(@output_file, 'a') do |out|
    output = [reading, smoothed_reading1, smoothed_reading2, smoothed_reading3]#, @detected]
    puts output.inspect
    out.puts CSV.generate_line(output)
  end


  return window1,window2,window3
end


#file = "#{File.dirname(__FILE__)}/../recorded_data/13-06-28.csv"
file = "#{File.dirname(__FILE__)}/../recorded_data/one_cycle.csv"

@output_file = "#{File.dirname(__FILE__)}/../recorded_data/analysis.csv"

`rm #{@output_file}`

def get_status(reading)
  if reading == 0
    "Precisely empty"
  elsif reading < 0
    "Not on scale"
  elsif reading > 100
    "Over maximum"
  else
    "In range"
  end
end

# averaging window array
window1 = []
window2 = []
window3 = []


CSV.foreach(file) do |line|

  reading = line[1].to_f


# setting data in the same way I did before the scale
  get_data


  #classic_detection(reading)
  window1,window2,window3 = smoothing(reading,window1,window2,window3)

end
