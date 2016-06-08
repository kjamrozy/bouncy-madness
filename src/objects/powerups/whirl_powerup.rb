require_relative 'powerup'

# WhirlPowerup - dziedziczy po Powerup. Gracz otrzymuje nową broń.
class WhirlPowerup < Powerup
  def initialize(scene, params = {})
    super(scene, params)
    @img = Gosu::Image.new('media/images/whirl_powerup.png')
    @max_y = @scene.height - @img.height
    @id = 1
  end

  # Ustawia nową broń jako broń główną
  def invoke
    @scene.player.projectile = WhirlProjectile
    @scene.player.powerups[@id] = nil
  end
end
