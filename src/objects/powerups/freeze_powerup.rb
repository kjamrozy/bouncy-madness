require_relative 'powerup'

# freezes balls for 3 seconds
class FreezePowerup < Powerup
  def initialize(scene, params = {})
    super(scene, params)
    @img = Gosu::Image.new('media/images/freeze_powerup.png')
    @max_y = @scene.height - @img.height
    @id = 9
  end

  def invoke
    @scene.freeze(3000)
    @scene.player.powerups[9] = nil
  end
end
