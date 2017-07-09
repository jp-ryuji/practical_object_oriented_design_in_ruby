class Bicycle
  attr_reader :size, :parts

  def initialize(args = {})
    @size = args[:size]
    @parts = args[:parts]
  end

  def spares
    parts.spares
  end
end

require 'forwardable'
class Parts
  extend Forwardable
  def_delegators :@parts, :size, :each
  include Enumerable

  attr_reader :parts

  def initialize(parts)
    @parts = parts
  end

  def spares
    select { |part| part.needs_spare }
  end
end

class Part
  attr_reader :name, :description, :needs_spare

  def initialize(args)
    @name = args[:name]
    @description = args[:description]
    @needs_spare = args.fetch(:needs_spare, true)
  end
end

# This factory knows the structure config.
# Then config can be kept simple.
module PartsFactory
  def self.build(config, part_class = Part, parts_class = Parts)
    parts_class.new(
      config.collect do |part_config|
        part_class.new(
          name: part_config[0],
          description: part_config[1],
          needs_spare: part_config.fetch(2,  true)
        )
      end
    )
  end
end

road_config = [
  ['chain', '10-speed'],
  ['tire_size', '23'],
  ['tape_color', 'red']
]

moutain_config = [
  ['chain', '10-speed'],
  ['tire_size', '2.1'],
  ['front_shock', 'Manitou', 'red'],
  ['rear_shock', 'Fox']
]

road_parts = PartsFactory.build(road_config)
mountain_parts = PartsFactory.build(mountain_config)

# road_bike = Bicycle.new(size: 'L', parts: RoadBikeParts.new(tape_color: 'read'))
# road_bike.size
# road_bike.spares
#

# chain = Part.new(name: 'chain', description: '10-speed')
# road_tire = Part.new(name: 'chain', description: '10-speed')
# front_shock = Part.new(name: 'front_shock', description: 'Manitou', needs_spare: false)
# road_bike_parts = Parts.new([chain, road_tire, tape])
road_bike = Bicycle.new(size: 'L', parts: road_bike_parts)
