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

The aim of this installation is a 'closed box' running the Teabot without maintenance.

This has been tested with Ubuntu Server Edition on a netbook, but a Rasperry Pi teabot is on the roadmap.

* Install Ubuntu Server Edition (http://www.ubuntu.com/download/server). I recommend calling the computer and user 'teabot'
* `sudo apt-get install ruby rubygems git apache2 openssh-server`
* Generate an ssh key and add it to your github account (you will need a github account) as described in https://help.github.com/articles/generating-ssh-keys
* `cd /opt`
* `git clone git@github.com:AJFaraday/teabot.git`
* `cd teabot`
* `gem install bundler`
* `bundle install`
* `sudo cp xtra/teabot_scale.init-d.template /etc/init.d/teabot_scale`
* `sudo chmod 755 /etc/init.d/teabot_scale`
* `sudo /etc/init.d/teabot_scale start` (look for 'Starting teabot polling at /opt/teabot/scripts/teabot_scale.rb'
* Plug in the DYMO M5, and turn it on
* `tail -f data/working_data.yml` and check that the weight property changes with the scale.
* `sudo update-rc.d teabot_scale defaults`
* `gem install passenger`
* `sudo passenger-install-apache2-module` (and follow the many instructions on screen)
* `sudo cp xtra/default.apache.template /etc/apache2/sites-available/default`
* `sudo /etc/init.d/apache2 restart`

You should now be able to point another computer at the IP address of the teabot machine and see the site in action.

*Notes:*
* I have carried this installation out, but not following these instructions, I may well have missed many dependencies.
* I have found zenmap is the easiest way to find the teabot from another machine, just scan 192.168.0.* or 192.168.1.* and look for the name 'teabot' if you used it on installing Ubuntu Server
* If all goes well, on first use you will be directed to the calibration wizard, he's a nice chap, just do as he says and all will be well.

Minimum Dedicated Teabot Server Specification
---------------------------------------------

As tested, to date:

* 512mb memory
* 4gb hard-drive
* 1 usb port
* 1 ethernet socket

Needless to say, not very much!

Technologies
------------

The Teabot was developed by Andrew Faraday, a Ruby on Rails developer, and uses these technologies.

* Sinatra
* Yaml as a data store
* jQuery and jQuery UI
* libusb to read raw usb data




No teapots were harmed in the creation of this application.
