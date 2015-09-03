require_relative 'player'
require_relative 'objects/hostile/ball'

# GameScene class is in charge of holding objects which appear on the screen
class GameScene
  attr_reader :objects
  def initialize(context)
    @window = context
    @objects = [] << Ball.new(self, y: 20, y_velocity: 0.001)
    @player = Player.new(self, 0, 520)
    @background = Gosu::Image.new('media/images/background.png')
  end

  def add_object(obj)
    @objects.push(obj)
  end
  
  def draw
    @background.draw(0, 0, -1)
    @objects.each(&:draw)
    @player.draw
  end

  def update(interval)
    exit if Gosu.button_down? Gosu::KbEscape

    @player.mov = 0
    @player.mov = -1 if Gosu.button_down? Gosu::KbLeft
    @player.mov = 1 if Gosu.button_down? Gosu::KbRight
    @player.shot if Gosu.button_down?(Gosu::KbSpace) && @player.cooldown?

    @objects.keep_if { |obj| obj.update(interval) }
    @player.update(interval)
  end
end
