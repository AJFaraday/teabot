require 'rubygems'
require 'yaml'

# grabs data from yaml file
def get_data
  @data = YAML.load_file(File.dirname(__FILE__) + '/../data/working_data.yml')
  @data ||= {}
end

# expands/overrides stored data with given hash
def set_data(data={})
  @data ||= get_data
  @data.merge!(data)
  File.open(File.dirname(__FILE__) + '/../data/working_data.yml', 'w' ) do |out|
    YAML.dump( @data, out )
  end
end

# currently mock, read number from scale
# TODO find a way to read a real scale
def read_scale
  YAML.load_file(File.dirname(__FILE__) + '/../data/scale.yml')
end


def mock_set_scale(weight=10)
  File.open(File.dirname(__FILE__) + '/../data/scale.yml', 'w' ) do |out|
    YAML.dump(weight, out )
  end
end

alias :finger :mock_set_scale
