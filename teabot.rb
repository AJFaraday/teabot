require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra/base'
require 'erb'
require 'json'
require 'activesupport'

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
    if @data.empty?
      message = "The teabot knows nothing! Please calibrate the scales."
      redirect "/calibrate?message=#{message}"
    end
    # This will be the general info view about the teapot
    display(:index)
  end

  get '/teapot_data' do
    message = ''
    if @data[:weight]<@data[:empty_weight]
      message = "Teapot not currently on scale..."
      update = false
    else
      update = true
    end
    if percent_fill > 100
      message = "Teapot is over 100% full, consider re-calibrating the scale."
    end

    if @data[:last_filled] > (Time.now - (60*6)) and @data[:last_filled] < (Time.now - (60*5))
      notify = true
    else
      notify = false
    end

    data = {
      :percent_fill => percent_fill,
      :teapot_name => @data[:current_teapot],
      :cups => cup_fill,
      :notify => notify,
      :cup_capacity => @data[:cup_capacity],
      :message => message,
      :change => update,
      :last_made => last_filled,
      :current_tea => @data[:current_tea],
      :current_pourer => @data[:current_pourer]
    }.to_json
    puts data
    data
  end



  get '/teapot_station' do
    # This will be the interface at the teapot station
    display(:teapot_station)
  end

  post '/set_current_teapot' do
    teapot = params[:current_teapot]
    if teapot_names.include?(teapot)
      set_data({:current_teapot => teapot}.merge(get_teapots[teapot]))
      "Teapot profile set to #{teapot}"
    else
      "Something's wrong: #{teapot} doesn't seem to be on the list."
    end
  end

  post '/remove_teapot' do
    name = params[:remove_teapot_name]
    if name == ''
      @error = "If you want to remove a teapot, select one."
    else
      remove_teapot(name)
      @message = "Removed #{name} from the list of teapots."
    end
    display(:teapot_station)
  end

  post '/set_pourer' do
    pourer = params[:current_pourer]
    if pourers.include?(pourer)
      set_data({:current_pourer => pourer})
      "Nice one, #{pourer}!"
    else
      "Something's wrong: #{pourer} doesn't seem to be on the list."
    end
  end

  post '/add_pourer' do
    name = params[:new_pourer_name]
    if name.empty?
      @error = "If you want to add a pourer, tell me their name."
    else
      add_pourer(name)
      @message = "Added #{name} to the list of pourers."
    end
    display(:teapot_station)
  end

  post '/remove_pourer' do
    name = params[:remove_pourer_name]
    if name == ''
      @error = "If you want to remove a pourer, select one."
    else
      remove_pourer(name)
      @message = "Removed #{name} from the list of pourers."
    end
    display(:teapot_station)
  end
  
  
  
  post '/set_tea' do
    tea = params[:current_tea]
    if teas.include?(tea)
      set_data({:current_tea => tea})
      "Tea set to #{tea}!"
    else
      "Something's wrong: #{tea} doesn't seem to be on the list."
    end
  end

  post '/add_tea' do
    name = params[:new_tea_name]
    if name.empty?
      @error = "If you want to add a tea, tell me their name."
    else
      add_tea(name)
      @message = "Added #{name} to the list of teas."
    end
    display(:teapot_station)
  end

  post '/remove_tea' do
    name = params[:remove_tea_name]
    if name == ''
      @error = "If you want to remove a tea, select one."
    else
      remove_tea(name)
      @message = "Removed #{name} from the list of teas."
    end
    display(:teapot_station)
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
        set_data(:empty_weight => read_scale)
        erb(:_calibrate_step2)
      when '3'
        weight = read_scale
        if weight.to_f > @data[:empty_weight].to_f
          set_data({:cup_weight => (weight.to_f - @data[:empty_weight].to_f)})
          erb(:_calibrate_step3)
        else
          @error = "A teapot usually gets heavier when you add a cup of water. Are you sure you're not filling it with helium?"
          erb(:_calibrate_step2)
        end
      when '4'
        weight = read_scale
        if weight.to_f >= (@data[:empty_weight]+@data[:cup_weight])
          cup_capacity = ((weight.to_f-@data[:empty_weight].to_f)/@data[:cup_weight].to_f).to_i
          set_data(:full_weight => weight, :cup_capacity => cup_capacity)
          # A list of saved teapot names
          @teapots = teapot_names
          erb(:_calibrate_step4)
        else
          @error = "A teapot usually gets heavier when you fill it up. Are you sure you filled it?"
          erb(:_calibrate_step3)
        end
      when '5'
        if params[:teapot][:name] == 'new'
          name = params[:teapot][:new_name] if params[:teapot][:new_name].any?
          name ||= "Unnamed Teapot"
        else
          name = params[:teapot][:name]
        end
        write_teapot(name,
                     @data[:empty_weight],
                     @data[:cup_weight],
                     @data[:full_weight],
                     @data[:cup_capacity])
        set_data({:current_teapot => name})
        @message = "You've saved this teapot '#{name}' for future use."
        redirect "/?message=#{@message}"
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
