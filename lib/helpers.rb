require 'rubygems'
require 'yaml'
require File.dirname(__FILE__) + '/time-ago-in-words.rb'
require 'libusb'
require 'active_support'

def yaml_path(name='working_data')
  File.dirname(__FILE__) + "/../data/#{name}.yml"
end

# A method of convenience to get yaml from the data folder
def fetch_yaml(name='working_data')
  system "touch #{yaml_path(name)}"
  result = YAML.load_file(yaml_path(name))
  result ||= {}
  result
end

# grabs data from yaml file
def get_data
  @data = fetch_yaml 'working_data'
  @data ||= {}
end

# expands/overrides stored data with given hash
def set_data(data={},hide_debug=false)
  @data = get_data
  @data.merge!(data)
  File.open(yaml_path('working_data'), 'w') do |out|
    YAML.dump(@data, out)
  end
  unless hide_debug
    puts "Setting data:"
    puts @data.inspect
  end
end

def percent_fill
  get_data
  if @data[:weight] and @data[:empty_weight]
    # weight of the tea (not the pot)
    modified_weight = @data[:weight]-@data[:empty_weight]
    # weight of a pot of tea (but not the pot)
    modified_full_weight = @data[:full_weight]-@data[:empty_weight]
    ((modified_weight/modified_full_weight)*100).to_i
  else
    puts "percent fill not calcuated"
    0.0
  end
end

# How many cups are in the pot
def cup_fill
  ((percent_fill/100.0)*@data[:cup_capacity]).to_i
end




def mock_set_scale(weight=10)
  File.open(yaml_path('scale'), 'w') do |out|
    YAML.dump(weight, out)
  end
end

alias :finger :mock_set_scale

def get_teapots
  fetch_yaml('teapots')
end

def teapot_names
  get_teapots.keys.sort
end

def get_teapot(name='')
  get_teapots[name]
end

def remove_teapot(name)
  teapots = get_teapots
  teapots.delete(name)
  File.open(yaml_path('teapots'), 'w') do |out|
    YAML.dump(
      teapots,out
    )
  end
end

def write_teapot(name, empty, cup, full, cup_capacity)
  teapots = get_teapots
  File.open(yaml_path('teapots'), 'w') do |out|
    YAML.dump(
      teapots.merge({name => {
                        :empty_weight => empty,
                        :cup_weight => cup,
                        :full_weight => full,
                        :cup_capacity => cup_capacity
                      }
                    }),
      out
    )
  end
end

def pourers
  list = fetch_yaml('pourer')
  list = [] if list.is_a?(Hash)
  list.sort
end

def add_pourer(name)
  list = (pourers << name).uniq
  File.open(yaml_path('pourer'), 'w') do |out|
    YAML.dump(list, out)
  end
  set_data({:current_pourer => name})
end

def remove_pourer(name)
  list = pourers - [name]
  File.open(yaml_path('pourer'), 'w') do |out|
    YAML.dump(list, out)
  end
end

def teas
  list = fetch_yaml('tea')
  list = [] if list.is_a?(Hash)
  list.sort
end

def add_tea(name)
  list = (teas << name).uniq
  File.open(yaml_path('tea'), 'w') do |out|
    YAML.dump(list, out)
  end
  set_data({:current_tea => name})
end


def remove_tea(name)
  list = teas - [name]
  File.open(yaml_path('tea'), 'w') do |out|
    YAML.dump(list, out)
  end
end

def last_filled
  begin
  @data[:last_filled].time_ago_in_words
  rescue
    ""
  end
end



# Stuff just for CSV recording of live data
require 'csv'
def record_data(reading)
  get_data
  CSV
  modified_weight = reading.to_f - @data[:empty_weight]
  modified_full_weight = @data[:full_weight]-@data[:empty_weight]
  percent = ((modified_weight/modified_full_weight)*100).to_i
  get_data
  # Actual data to record
  line = [
    Time.now.seconds_since_midnight.to_i,
    percent
  ]
  # make correctly formatted CSV line
  line = CSV.generate_line(line)

  file_path = "File.dirname(__FILE__)/../recorded_data/#{Time.new.strftime('%y-%m-%d')}.csv"
  File.open(file_path, 'a') do |file|
    file.puts line
  end
end
