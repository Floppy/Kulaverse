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
      data = JSON.parse(File.read(File.join(Rails.root, 'app', 'levels', options[:world_num].to_s, "#{options[:level_num]}.json")))
      data[:world_num] = options[:world_num]
      data[:level_num] = options[:level_num]
      [Level.new(data)]
    elsif options[:world_num]
      Dir.glob(File.join(Rails.root, 'app', 'levels', options[:world_num].to_s, "*.json")).map do |x| 
        File.basename(x).split('.')[0].to_i
      end.sort
    else
      raise 'provide :world_num and optionally :level_num'
    end
  end
  
end