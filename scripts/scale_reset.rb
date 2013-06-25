#
# This script clears the deadlock which appears to be taken out on plugging in or turning on the scale
#
# No, I don't know how to do this in the read_scale script without causing further errors.
#


require 'rubygems'
require 'libusb'

usb = LIBUSB::Context.new
device = usb.devices(:idVendor => 0x0922, :idProduct => 0x8005).first

handle = device.open()

begin
  handle.detach_kernel_driver(0)
  puts "detached driver"
rescue => er
  puts er.message
  puts "didn't have to detach driver"
end

handle.close
