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
* `rackup config.ru`
* Point your browser to localhost:9292
* Click 'Calibrate Scale' and follow instructions (you may have to wait a second between loading the scale and proceeding).
* Make a brew

After initial setup:

* `cd teabot`
* Start polling scale with: `sudo ruby scripts/read_scale.rb`
* `rackup config.ru`
* Point your browser to localhost:9292
* Make a Brew

This will probably work in the same way for MAC, almost certainly not for Windows. 

For another brand or model of scale, some hacking will be required.


Special Setup Instructions
--------------------------

These are instructions for setting up a *dedicated Teabot server!* This means:

* The teabot server and USB polling scripts will begin on startup
* The web interface is served via apache
* You point the browser at the machine itself, without the port number (:9292)
* You need never look at the screen of the teabot server after setup

This has been tested with Ubuntu Server Edition(http://www.ubuntu.com/download/server),
but a Rasperry Pi teabot is on the roadmap.




Technologies
------------

The Teabot was developed by Andrew Faraday, a Ruby on Rails developer, and uses these technologies.

* Sinatra
* Yaml as a data store
* jQuery and jQuery UI
* libusb to read raw usb data




No teapots were harmed in the creation of this application.
