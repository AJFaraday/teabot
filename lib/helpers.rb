require 'rubygems'
require 'yaml'

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
def set_data(data={})
  @data = get_data
  @data.merge!(data)
  File.open(yaml_path('working_data'), 'w') do |out|
    YAML.dump(@data, out)
  end
  puts "Setting data:"
  puts @data.inspect
end

def percent_fill
  get_data
  # weight of the tea (not the pot)
  modified_weight = @data[:weight]-@data[:empty_weight]
  # weight of a pot of tea (but not the pot)
  modified_full_weight = @data[:full_weight]-@data[:empty_weight]
  ((modified_weight/modified_full_weight)*100).to_i
end


# currently mock, read number from scale
# TODO find a way to read a real scale
def read_scale
  weight = fetch_yaml('scale')
  puts "Read the scale: #{weight}"
  weight
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
  get_teapots.keys
end

def get_teapot(name='')
  get_teapots[name]
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