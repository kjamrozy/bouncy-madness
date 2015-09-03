# main projectile class
class Projectile
  def initialize(scene, x, y, params = {})
    @scene = scene
    @x = x
    @y = y

    @scale = params[:scale] || 1.0
    @vy = params[:y_velocity] || 0.5
  end

  def update(interval)
    @y = [@y - interval * @vy, 0].max
  end
end