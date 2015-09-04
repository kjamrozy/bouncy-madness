require 'gosu'
require_relative 'game_scene'

# game window
class Game < Gosu::Window
  attr_accessor :cursor
  def initialize
    super(800, 600)
    self.caption = 'Bouncy madness'
    @scene = GameScene.new(self)
    @x = @y = 300
    @r = 50
    @cursor = false
  end

  def draw
    @scene.draw
  end

  def update
    @scene.update(update_interval)
  end

  def needs_cursor?
    @cursor
  end
end
