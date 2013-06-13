require 'rubygems'
require 'net/http'
require 'json'
# Collect data

# totally real scale...
weight = ARGV[0]
weight ||= 100

# send HTTP stuff 
uri = URI('http://localhost:9292/weight_data')
request = Net::HTTP.post_form(uri,  {:weight => weight})
puts request.body
