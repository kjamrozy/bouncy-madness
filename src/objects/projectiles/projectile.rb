require_relative '../../helpers/object_helper'
require_relative '../base_object'

# main projectile class, it is not meant to instantiate
class Projectile < BaseObject
  include ObjectHelper
  def initialize(scene, params = {})
    super(scene, params)
    @vy = params[:y_velocity] || 0.5
    @z = PROJECTILE
  end

  def update(interval)
    @y = [@y - interval * @vy, 0].max
  end

  def cooldown
    1000
  end
end