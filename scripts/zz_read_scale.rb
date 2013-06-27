# This is a specific attempt to place the USB reset in nested loops,
# The aim is that the script could recover from the scale being
# unplugged or turned off.

require 'rubygems'
require 'libusb'
require File.dirname(__FILE__) + '/../lib/helpers.rb'

def get_usb_device
  usb = LIBUSB::Context.new
  usb.devices(:idVendor => 0x0922, :idProduct => 0x8005).first
end

# TODO move this to a common file for mock_scale.rb

def set_weight(reading)
  get_data
  if @data[:empty_weight] and @data[:last_positive_weight]
    # Normal Working

    modified_weight = reading.to_f - @data[:empty_weight]
    modified_full_weight = @data[:full_weight]-@data[:empty_weight]
    percent = ((modified_weight/modified_full_weight)*100).to_i

    if ((reading.to_f > (@data[:last_positive_weight].to_f * 1.1)) and
      (reading > @data[:empty_weight]) and
      percent > 80 and percent < 110 and
      reading.to_f == @data[:weight].to_f
    )
      puts "Looks like the teapot's been filled again."
      set_data({:weight => reading.to_f, :last_filled => Time.now}, true)
    else
      set_data({:weight => reading.to_f}, true)
    end
  else
    # For pre-setup teabot
    set_data({:weight => reading.to_f}, true)
  end
  if reading > @data[:empty_weight].to_f
    set_data({:last_positive_weight => reading}, true)
  end
end


loop do
  device = get_usb_device
  if device
    begin
      device.open_interface(0) do |handle|
        begin
          handle.detach_kernel_driver(0)
          puts "detached driver"
        rescue => er
          puts er.message
          puts "didn't have to detach driver"
        end
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
          reading = bytes[4] + (bytes[5]* 255)
          puts "Scale reads: #{reading}"

          set_weight(reading)


          sleep 1
        end
      end
    rescue => er
      puts "ERROR OCCURRED!"
      puts er.message
      puts "try `ruby scripts/scale_reset.rb`"
    end
  else
    puts "Scale not currently discoverable"
    sleep 1
    puts "Retrying..."
  end

end