require 'gosu'

class Game < Gosu::Window
  def initialize
    super(800,600)
    self.caption = 'Bouncy madness'
  end
end
