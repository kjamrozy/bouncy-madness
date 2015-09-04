require_relative 'projectile'

# Whirl projectile class
class WhirlProjectile < Projectile
  def initialize(scene, params = {})
    super(scene, params)

    @rot = params[:initial_rotation] || 0.0
    @rot_speed = params[:rot_speed] || 0.002

    @img = Gosu::Image.new('media/images/whirl_projectile.png')
    @x -= [(@img.width - @scene.player.img.width) / 2, 0].max
    @y -= [@img.width, 0].max
  end

  def draw
    @img.draw_rot(
      @x + @img.width * 0.5, @y + @img.height * 0.5,
      2, @rot, 0.5, 0.5, @scale, @scale)
  end

  def update(interval)
    super(interval)
    @rot += interval * @rot_speed * 360
    @rot -= Integer(@rot / 360) * 360
    @keep = false if @y <= 0
  end

  # this projectile should have stricter collision box
  def cbox
    width = Integer(@img.width * 0.9)
    offset = Integer(@img.width * 0.05)
    [@x + offset, @x + offset + width, @y + offset, @y + offset + width]
  end
end