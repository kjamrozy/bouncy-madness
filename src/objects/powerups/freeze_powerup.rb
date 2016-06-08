require_relative 'powerup'

# FreezePowerup - dziecziczy po Powerup. Zamraża czas na 3s.
class FreezePowerup < Powerup
  # Inicjuje obiekt
  def initialize(scene, params = {})
    super(scene, params)
    @img = Gosu::Image.new('media/images/freeze_powerup.png')
    @max_y = @scene.height - @img.height
    @id = 9
  end

  # Zamraża czas
  def invoke
    @scene.freeze(3000)
    @scene.player.powerups[@id] = nil
  end
end
