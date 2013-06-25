require File.dirname(__FILE__) + '/../lib/helpers.rb'


loop do
  get_data
  puts "Type to simulate scale output:"
  weight = gets.strip.to_i
  if @data[:empty_weight] and @data[:last_positive_weight]
    # Normal Working

    modified_weight = weight.to_f - @data[:empty_weight]
    modified_full_weight = @data[:full_weight]-@data[:empty_weight]
    percent = ((modified_weight/modified_full_weight)*100).to_i

    if ((weight.to_f > (@data[:last_positive_weight].to_f * 1.1)) and
      (weight > @data[:empty_weight]) and
      percent > 85
    )
      puts "Looks like the teapot's been filled again."
      set_data({:weight => weight.to_f, :last_filled => Time.now}, true)
    else
      set_data({:weight => weight.to_f}, true)
    end

  else
    # For pre-setup teabot
    set_data({:weight => weight.to_f}, true)
  end
  if weight > @data[:empty_weight].to_f
    set_data({:last_positive_weight => weight.to_f}, true)
  end
end
