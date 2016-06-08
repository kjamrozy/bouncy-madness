require_relative '../../helpers/object_helper'
require_relative '../base_object'

# Projectile - dziedziczy po BaseObject. Posiada bazową prędkość i cooldown. Znika po dotarciu do górnej krawędzi ekranu.
class Projectile < BaseObject
  include ObjectHelper
  def initialize(scene, params = {})
    super(scene, params)
    @vy = params[:y_velocity] || 0.5
    @z = PROJECTILE
  end

  # Uaktualnia wysokość pocisku.
  def update(interval)
    @y = [@y - interval * @vy, 0].max
  end

  # Podaje cooldown do następnego strzału.
  def cooldown
    1000
  end
end