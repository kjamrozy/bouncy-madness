require_relative 'powerup'

# grants whirl weapon
class WhirlPowerup < Powerup
  def initialize(scene, params = {})
    super(scene, params)
    @img = Gosu::Image.new('media/images/whirl_powerup.png')
    @max_y = @scene.height - @img.height
    @id = 1
  end

  def invoke
    @scene.player.projectile = WhirlProjectile
    @scene.player.powerups[@id] = nil
  end
end
