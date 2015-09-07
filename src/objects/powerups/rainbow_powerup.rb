require_relative 'powerup'

# freezes balls for 3 seconds
class RainbowPowerup < Powerup
  def initialize(scene, params = {})
    super(scene, params)
    @img = Gosu::Image.new('media/images/rainbow_powerup.png')
    @max_y = @scene.height - @img.height
    @id = 7
  end

  def invoke
    @scene.player.rainbow = 6000 
    @scene.player.powerups[@id] = nil
  end
end