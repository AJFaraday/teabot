require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra/base'
require 'erb'
require 'json'

require File.dirname(__FILE__) + '/lib/helpers.rb'


class Teabot < Sinatra::Base

  set :static, true
  set :public_dir, File.dirname(__FILE__) + '/static'

  before do
    get_data
    @message = params[:message]
  end

  get '/data' do
    @data.to_json
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

  get '/calibrate' do

    display(:_calibrate_step1)
  end

  #
  # fill individual piece of data (From scale)
  #
  post '/calibrate/:step' do
    case params[:step]
      when '2'
        puts 'at step 2'
        set_data(:empty_weight => read_scale)
        erb(:_calibrate_step2)
      when '3'
        puts 'at step 3'
        weight = read_scale
        set_data({:cup_weight => (weight.to_f - @data[:empty_weight].to_f)})
        erb(:_calibrate_step3)
      when '4'
        puts 'at step 4'
        set_data(:full_weight => read_scale)
        # A list of saved teapot names
        @teapots = teapot_names
        erb(:_calibrate_step4)
      when '5'
        if params[:teapot][:name] == 'new'
          name = params[:teapot][:new_name]
        else
          name = params[:teapot][:name]
        end
        write_teapot(name,
                     @data[:empty_weight],
                     @data[:cup_weight],
                     @data[:full_weight])

        @message = "You've saved this teapot '#{name}' for future use."
        redirect "/?message=#{@message}"
    end

  end

  # This blindly takes a forms content and adds it to
  # the data.yml file
  #
  # Will be used for scale_polling method
  post '/accept_data' do
    set_data(params)
    "Data Received! #{params.inspect} \n Data is now: #{@data.inspect}"
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
