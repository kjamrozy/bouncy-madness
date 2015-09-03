require 'gosu'
require_relative 'game_scene'

# game window
class Game < Gosu::Window
  def initialize
    super(800, 600)
    self.caption = 'Bouncy madness'
    @scene = GameScene.new(self)
    @x = @y = 300
    @r = 50
  end

  def draw
    @scene.draw
  end

  def update
    @scene.update(update_interval)
  end
end
