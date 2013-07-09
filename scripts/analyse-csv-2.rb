# Detection algorithm 2
#
# in range is from 0% to 110%
# detection range is 65% to 110%
#
# Algirithm is armed when weight has increased 10% from the last weight in range abd is within the detection range
#
# Algorithm is disarmed if weight moves out of detection range.
#
# If the algorithm is armed for 3 iterations, a new pot is detected

require 'rubygems'
require File.dirname(__FILE__) + '/../lib/helpers.rb'
require 'csv'


def modified_detection(reading)
  if @armed and reading > 65 and reading < 110
    if @n == 2
      #detected action
      puts "Looks like the teapot's been filled again."
      set_data({:weight => reading.to_f, :last_filled => Time.now}, true)
      @detected = 'FILL DETECTED'
      @armed = false
    else
      @n += 1
    end
  else
    set_data({:weight => reading.to_f}, true)
    @detected = ''
    @n = 0
    @armed = false
  end

  if (reading.to_f > (@data[:last_weight_in_range].to_f * 1.1)) and reading > 65 and reading < 110
    @armed = true
  end

  if reading > 0 and reading < 110
    set_data({:last_weight_in_range => reading}, true)
  end

end

@contraction_array = ['a', 'b', 'c']
file = "#{File.dirname(__FILE__)}/../recorded_data/13-07-08.csv"

@armed = false
@n = 0

@output_file = "#{File.dirname(__FILE__)}/../recorded_data/analysis-2.csv"

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


CSV.foreach(file) do |line|

  reading = line[1].to_f


  # setting data in the same way I did before the scale
  get_data


  modified_detection(reading)


  File.open(@output_file, 'a') do |out|
    @contraction_array << reading
    @contraction_array.shift if @contraction_array.length > 10
    unless @contraction_array.uniq.length == 1
      output = [reading, get_status(reading), @detected]
      puts output.inspect
      out.puts CSV.generate_line(output)
    end
  end

end
