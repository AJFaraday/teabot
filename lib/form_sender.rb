require 'rubygems'
require 'net/http'
require 'json'

def post(data={})
  # send HTTP stuff 
  uri = URI('http://localhost:9292/accept_data')
  request = Net::HTTP.post_form(uri,  data)
  puts request.body
end
