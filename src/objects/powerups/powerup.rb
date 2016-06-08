require_relative '../base_object'

# Powerup - dziedziczy po BaseObject. Posiada czas, po którym obiekt znika.
# Posiada atrybut alpha, który służy do stopniowego zanikania powerupu(po pewnym czasie staje się całkiem przezroczysty i znika).
class Powerup < BaseObject
  attr_reader :id
  def initialize(scene, params = {})
    super(scene, params)
    @time = params[:time] || 3000
    @alpha = 255
  end

  # Rysuje powerup na scenie.
  def draw
    color = Gosu::Color.rgba(255, 255, 255, @alpha)
    @img.draw(@x, @y, @z, @scale, @scale, color)
  end

  # Uaktualnia alphe powerupu.
  def update(interval)
    super(interval)
    @alpha -= 255 * interval / @time
  end
end
