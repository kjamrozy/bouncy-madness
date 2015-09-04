require_relative 'objects/projectiles/whirl_projectile'

# player class
class Player
  attr_reader :img
  attr_accessor :mov, :cooldown

  def initialize(scene, x, y, params = {})
    @scene = scene
    @x = x
    @y = y
    # movement variable, -1 for moving to the left,
    # 0 to not move at all, 1 to move to the right
    @mov = 0
    @velocity = params[:velocity] || 0.2
    @scale = params[:scale] || 1.0
    # point at time when player would be allowed to use weapon again
    @cooldown = Time.now - 1
    @projectile = WhirlProjectile

    @img = Gosu::Image.new('media/images/character.png')
  end

  def draw
    @img.draw(@x, @y, 1, @scale, @scale)
  end

  def update(interval)
    @x += interval * @velocity * @mov
  end

  # is cooldown on weapon off
  def cooldown?
    Time.now >= @cooldown
  end

  def shot
    projectile = @projectile.new(@scene, x: @x, y: @y)
    @scene.add_object(projectile)
    @cooldown = Time.now + 1
  end
end
