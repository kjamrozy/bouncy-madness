require_relative 'powerup'

# RainbowPowerup - dziedziczy po Powerup. Sprawia, że gracz staje się nietykalny, a jego postać zmienia losowo kolory podczas trwania bonusu.
class RainbowPowerup < Powerup
  def initialize(scene, params = {})
    super(scene, params)
    @img = Gosu::Image.new('media/images/rainbow_powerup.png')
    @max_y = @scene.height - @img.height
    @id = 7
  end

  # Używa powerupu
  def invoke
    @scene.player.rainbow = 6000 
    @scene.player.powerups[@id] = nil
  end
end
