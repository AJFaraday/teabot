TEABOT!!!!
----------

The office teapot solution. 

The Teabot works with a USB parcel scale (currently the DYMO M5) and provides a simple office solution to the age old question:

_Is there any tea?_

The Teabot reads the scale and informs visitors to it's home page how much tea there is at any one time. It's a simple idea for an aid to the everyday hot beverage production and procurement workflow. 

Features:
---------

* Teapot Calibration Wizard
* Teapot Station Interface featuring choices of Pourer, Tepot and Tea
* Automatic Teapot Replenishment Detection
* jQuery Animated Teapot
* Cup Capacity Estimation
* 5 Minute Notification for the Perfect Brew
* Tea age and level are indicated

![Screenshot](/teabot-screenshot.png)


Instructions
------------

With a linux box and a DYMO M5 scale, this initial setup should work:

* `git clone git@github.com:AJFaraday/teabot.git`
* `cd teabot`
* `bundle install`
* Start polling scale with: `sudo ruby scripts/read_scale.rb`
* If the previous script stops try `sudo ruby scripts/scale_reset.rb` and repeat
* `rackup config.ru`
* Point your browser to localhost:9292
* 


This will probably work in the same way for MAC, almost certainly not for Windows. 

For another brand or model of scale, some hacking will be required.


Technologies
------------

The Teabot was developed by Andrew Faraday, a Ruby on Rails developer, and uses these technologies.

* Sinatra
* Yaml as a data store
* jQuery and jQuery UI
* libusb to read raw usb data




No teapots were harmed in the creation of this application.
