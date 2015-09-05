require_relative 'objects/projectiles/whirl_projectile'
require_relative 'helpers/object_helper'

# player class
class Player
  attr_reader :img, :x, :y
  attr_accessor :mov, :cooldown

  def initialize(scene, params = {})
    @scene = scene
    # movement variable, -1 for moving to the left,
    # 0 to not move at all, 1 to move to the right
    @mov = 0
    @velocity = params[:velocity] || 0.2
    @scale = params[:scale] || 1.0
    # point at time when player would be allowed to use weapon again
    @cooldown = Time.now - 1
    @projectile = WhirlProjectile

    @imgs = Gosu::Image.load_tiles('media/images/character.png', 89, 120)
    @img = @imgs[0]
    @elapsed = 0
    @frame = 0
    @x = params[:x] || Integer(@scene.width/2 - @img.width/2)
    @y = params[:y] || @scene.height - @img.height
  end

  def draw
    @img.draw(@x, @y, 1, @scale, @scale)
  end

  def update(interval)
    animate_player(interval) unless @mov == 0
    @mov = 0
    @mov = -1 if Gosu.button_down? Gosu::KbLeft
    @mov = 1 if Gosu.button_down? Gosu::KbRight
    @x += interval * @velocity * @mov
  end

  # computer current character frame
  def animate_player(interval)
    @elapsed += interval
    @frame += @elapsed / 1000
    @elapsed -= (@elapsed / 1000) * @elapsed
    @frame %= 12
    @img = @imgs[@frame]
  end

  # is cooldown on weapon off
  def cooldown?
    Time.now >= @cooldown
  end

  def shot
    projectile = @projectile.new(@scene)
    @scene.add_object(projectile)
    @cooldown = Time.now + projectile.cooldown
  end

  # collision boxes
  def cbox
    [[27, 1, 30, 6], [23, 7, 41, 3], [19, 10, 48, 6],
     [17, 6, 55, 5], [17, 21, 55, 28], [13, 19, 4, 30],
     [2, 93, 85, 25], [5, 80, 81, 93], [14, 39, 59, 31],
     [8, 52, 6, 17], [72, 49, 8, 20], [80, 52, 4, 16],
     [72, 25, 5, 24], [7, 72, 6, 9], [72, 69, 6, 11]]
      .collect { |el| box_for(el[0] + @x, el[1] + @y, el[2], el[3]) }
  end

  private

  def box_for(x, y, width, height)
    [x, x + width, y,  y + height]
  end
end
