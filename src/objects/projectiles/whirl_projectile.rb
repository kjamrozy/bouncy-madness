require_relative 'projectile'

# Whirl projectile class
class WhirlProjectile < Projectile
  def initialize(scene, x, y, params = {})
    super(scene, x, y, params)

    @rot = params[:initial_rotation] || 0.0
    @rot_speed = params[:rot_speed] || 0.002

    @img = Gosu::Image.new('media/images/whirl_projectile.png')
  end

  def draw
    @img.draw_rot(@x, @y, 2, @rot, 0.5, 0.5, @scale, @scale)
  end

  def update(interval)
    super(interval)
    @rot += interval * @rot_speed * 360
    @rot -= Integer(@rot / 360) * 360
    @y > 0 ? true : false
  end
end