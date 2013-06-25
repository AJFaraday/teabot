#
# Earlier on I tried borrowing this from elsewhere and more thoroughly produced
# eventually decided on a purely
#


require 'time'

class Time


  def time_ago_in_words
    time_difference = Time.now.to_i - self.to_i

    if time_difference > 60
      "#{(time_difference.to_f % 60).to_i} minutes ago"
    else
      "less than a minute ago"
    end

  end

end
