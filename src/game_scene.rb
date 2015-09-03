# GameScene class is in charge of holding objects which appear on the screen
class GameScene
  attr_reader :objects
  def initialize
    @objects = []
  end

  def draw
    @objects.each { |obj| obj.draw }
  end

  def update
    @objects.keep_if { |obj| obj.update }
  end
end
