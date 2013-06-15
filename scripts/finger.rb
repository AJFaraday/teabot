require 'lib/helpers.rb'

puts "Type a number to put your finger on the scale."
loop do
  number = gets
  finger(number.to_f)
  puts "The scale now shows #{number.to_f}."
end
