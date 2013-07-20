require 'rubygems'
require 'libusb'
require File.dirname(__FILE__) + '/../lib/helpers.rb'

@armed = false
@n = 0

loop do
  loop do
    usb = LIBUSB::Context.new
    device = usb.devices(:idVendor => 0x0922, :idProduct => 0x8005).first

    begin
      device.open_interface(0) do |handle|

        loop do


          data = handle.bulk_transfer(:endpoint => 0x82, :dataIn => 0x0008)
          # output raw byte data
          data.each_byte do |byte|
            print byte.to_s.ljust(5)
          end
          puts
          bytes = data.bytes.to_a

          # byte 0 is always 3 - meaning unknown

          # byte 1 appears to be a status message, these are the ones I've decoded
          result = case bytes[1]
            when 2
              'Scale is at 0'
            when 4
              'Valid Reading'
            when 5
              'Below Zero - Reset Tare Weight'
            when 6
              'Teapot is Too Fat - Put it on a Diet'
          end
          puts result

          # byte 2 is always 11 - meaning unknown

          # bytes 4 and 5 represent the scale reading
          # byte 4 is multiples of 1
          # byte 5 is multiples of 255
          reading = bytes[4] + (bytes[5]* 256)
          puts "Scale reads: #{reading}"

          # setting data in the same way I did before the scale
          get_data

          if @data[:empty_weight] and @data[:full_weight]
            # Normal Working


            modified_weight = reading.to_f - @data[:empty_weight]
            modified_full_weight = @data[:full_weight]-@data[:empty_weight]
            percent = ((modified_weight/modified_full_weight)*100).to_i

            if ((reading.to_f > (@data[:last_weight_in_range].to_f * 1.1)) and
              @data[:weight] < @data[:empty_weight] and
            percent > 65 and percent < 110
            )
              @armed = true
            end
            if @armed and percent > 65 and percent < 110
              if @n == 2
                puts "Looks like the teapot's been filled again."
                set_data({:weight => reading.to_f, :last_filled => Time.now}, true)
                @armed = false
              else
                @n += 1
              end
            else
              set_data({:weight => reading.to_f}, true)
              @armed = false
              @n = 0
            end

            if percent > 0 and percent < 110
              set_data({:last_weight_in_range => reading}, true)
            end

          else
            # For pre-setup teabot
            set_data({:weight => reading.to_f}, true)

          end

          record_data(reading)

          sleep 1
        end
      end
    rescue => er
      puts "ERROR OCCURRED!"
      puts er.message
      puts "try `ruby scale_reset.rb`"
      `cd #{File.dirname(__FILE__)} && ruby scale_reset.rb`
      sleep 1
    end
  end
end
