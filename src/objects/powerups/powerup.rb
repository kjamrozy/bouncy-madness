require_relative '../base_object'

# freezes balls for 3 seconds
class Powerup < BaseObject
  attr_reader :id
  def initialize(scene, params = {})
    super(scene, params)
    @time = params[:time] || 3000
    @alpha = 255
  end

  def draw
    color = Gosu::Color.rgba(255, 255, 255, @alpha)
    @img.draw(@x, @y, @z, @scale, @scale, color)
  end

  def update(interval)
    super(interval)
    @alpha -= 255 * interval / @time
  end
end
