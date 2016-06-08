require_relative 'powerup'
require_relative '../projectiles/line_projectile'

# LinePowerup - dziecziczy po Powerup. Gracz otrzymuje nową broń.
class LinePowerup < Powerup
  def initialize(scene, params = {})
    super(scene, params)
    @img = Gosu::Image.new('media/images/line_powerup.png')
    @max_y = @scene.height - @img.height
    @id = 0
  end
  # Sprawia, że gracz używa nowej broni
  def invoke
    @scene.player.projectile = LineProjectile
  end
end
