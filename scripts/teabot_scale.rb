require 'rubygems'        # if you use RubyGems
require 'daemons'

Daemons.run(File.dirname(__FILE__)+'/read_scale.rb')