require_relative 'powerup'

# ShieldPowerup - dziedziczy po Powerup. Daje graczowi tarcze, która pozwala mu przyjąć uderzenie kulki. Po uderzeniu kulki tarcza znika.
class ShieldPowerup < Powerup
  def initialize(scene, params = {})
    super(scene, params)
    @img = Gosu::Image.new('media/images/shield_powerup.png')
    @max_y = @scene.height - @img.height
    @id = 8
  end

  # Używa powerup na graczu,
  def invoke
    @scene.player.shield = 256
    @scene.player.powerups[@id] = nil
  end
end
