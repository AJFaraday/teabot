require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra/base'
require 'erb'

class Teabot < Sinatra::Base
  
  get '/' do
    # This will be the general info view about the teapot
    display(:index)
  end

  get '/source' do
    # This will be the interface at the teapot station
    display(:source) 
  end

  post '/source' do
    # This will accept data from the source (tea maker etc)
    display(:source)
  end

  post '/weight_data' do
    # This will take the actual data from the scale
    display("Data recieved! #{params.inspect}")
  end

  def display_view(view)
    result = ''
    result << erb(:header)
    if view.is_a?(Symbol)
      result << erb(view)
    else
      result << view
    end
    result << erb(:footer)
    result
  end 

end
