require_relative 'powerup'
require_relative '../projectiles/line_projectile'

# freezes balls for 3 seconds
class LinePowerup < Powerup
  def initialize(scene, params = {})
    super(scene, params)
    @img = Gosu::Image.new('media/images/line_powerup.png')
    @max_y = @scene.height - @img.height
    @id = 0
  end

  def update(interval)
    super(interval)
  end

  def invoke
    @scene.player.projectile = LineProjectile
  end
end
