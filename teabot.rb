require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra/base'
require 'erb'

class Teabot < Sinatra::Base

  set :static, true
  set :public, File.dirname(__FILE__) + '/static'

  before do
    get_data
  end

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



  # This blindly takes a forms content and adds it to
  # the data.yml file
  #
  # Will be used for scale_polling method
  post '/accept_data' do
    set_data(params)
    "Data Received! #{params.inspect} \n Data is now: #{@data.inspect}"
  end

  def get_data
    @data = YAML.load_file('data.yml')
    @data ||= {}
  end

  def set_data(data={})
    @data.merge!(data)
    File.open( 'data.yml', 'w' ) do |out|
      YAML.dump( @data, out )
    end

  end

  def display(view)
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
