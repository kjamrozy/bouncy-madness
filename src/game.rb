require 'gosu'
require 'game_scene'

# game window
class Game < Gosu::Window
  def initialize
    super(800, 600)
    self.caption = 'Bouncy madness'
    @scene = GameScene.new
  end

  def draw
    @scene.draw
  end

  def update
    @scene.update
  end
end
