require_relative 'powerup'

# freezes balls for 3 seconds
class ShieldPowerup < Powerup
  def initialize(scene, params = {})
    super(scene, params)
    @img = Gosu::Image.new('media/images/shield_powerup.png')
    @max_y = @scene.height - @img.height
    @id = 8
  end

  def invoke
    @scene.player.shield = 256
    @scene.player.powerups[@id] = nil
  end
end
