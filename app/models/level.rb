require 'json'

class Level
  
  attr_accessor :level_num, :world_num, :start, :exit, :keys, :blocks, :entities
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def self.where(options)
    if options[:level_num] && options[:world_num]
      data = JSON.parse(File.read(File.join(Rails.root, 'app', 'levels', options[:world_num], "#{options[:level_num]}.json")))
      data[:world_num] = options[:world_num]
      data[:level_num] = options[:level_num]
      [Level.new(data)]
    elsif options[:world_num]
      
    else
      []
    end
  end
  
end