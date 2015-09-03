require_relative 'objects/ball'

# GameScene class is in charge of holding objects which appear on the screen
class GameScene
  attr_reader :objects
  def initialize(context)
    @window = context
    @objects = [] << Ball.new(self, y: 20, y_velocity: 0.001)
  end

  def add_object(obj)
    @objects.push(obj)
  end
  
  def draw
    @objects.each(&:draw)
  end

  def update(interval)
    @objects.keep_if { |obj| obj.update(interval) }
  end
end
