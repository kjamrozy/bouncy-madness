require 'gosu'
require_relative 'menu_scene'

# game window
class Game < Gosu::Window
  attr_accessor :cursor
  attr_accessor :scene
  def initialize
    super(800, 600)
    self.caption = 'BOUNCY MADNESS'

    @scene = MenuScene.new(self)
    @cursor = true
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
