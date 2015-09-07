require_relative 'objects/projectiles/whirl_projectile'
require_relative 'objects/projectiles/line_projectile'
require_relative 'helpers/object_helper'
require_relative 'game_constants'
require 'gosu'

# player class
class Player
  include GameConstants
  attr_reader :img, :x, :y, :color
  attr_accessor :mov, :cooldown, :powerups, 
                :projectile, :powerups, :shield, :rainbow

  def initialize(scene, params = {})
    @scene = scene
    # movement variable, -1 for moving to the left,
    # 0 to not move at all, 1 to move to the right
    @mov = 0
    @velocity = params[:velocity] || 0.2
    @scale = params[:scale] || 1.0
    # point at time when player would be allowed to use weapon again
    @cooldown = Gosu.milliseconds - 1
    @projectile = WhirlProjectile
    @shield = 256
    @shield_img = Gosu::Image.new('media/images/shield.png')

    @powerups = [false] * 10
    @powerups[0] = LinePowerup.new(@scene)
    @imgs = Gosu::Image.load_tiles('media/images/character.png', 89, 120)
    @img = @imgs[0]
    @rainbow = 0 
    @rainbow_img = Gosu::Image.new('media/images/ch_rainbow.png')
    @color = [100, 30, 240]
    @elapsed = 0
    @frame = 0
    @x = params[:x] || Integer(@scene.width/2 - @img.width/2)
    @y = params[:y] || @scene.height - @img.height
  end

  def draw
    if @rainbow > 0
      @rainbow_img.draw(@x, @y, PLAYER, @scale, @scale, Gosu::Color.rgba(@color[0], @color[1], @color[2], 150))
    else
      @img.draw(@x, @y, PLAYER, @scale, @scale)
    end
    
    offset = (@img.width - @shield_img.width) / 2
    @shield_img.draw(@x + offset, @scene.height - @shield_img.height, PLAYER, @scale, @scale, Gosu::Color.rgba(255, 255, 255, [@shield, 0].max))
  end

  def update(interval)
    animate_player(interval) unless @mov == 0
    @mov = 0
    @mov = -1 if Gosu.button_down? Gosu::KbLeft
    @mov = 1 if Gosu.button_down? Gosu::KbRight
    @x += interval * @velocity * @mov
    @shield -= interval / 1000.0 * 255 if @shield.between?(0, 255)
    @color.collect! { |c| [0, [255, c + rand * 30 - 15].min].max } if @rainbow > 0
    @rainbow -= interval if @rainbow > 0
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
    Gosu.milliseconds >= @cooldown
  end

  def shot
    projectile = @projectile.new(@scene)
    @scene.add_object(projectile)
    @cooldown = Gosu.milliseconds + projectile.cooldown
  end

  # collision boxes
  def cbox
    boxes = if @shield > 0
        [[33, -6, 25, 6], [26, -4, 7, 4], [21, 0, 48, 5],
         [16, 6, 58, 9], [8, 15, 74, 7], [4, 22, 82, 6],
         [82, 93, 4, 28], [-1, 29, 4, 85], [-4, 39, 3, 64],
         [-8, 54, 4, 35], [86, 29, 4, 85], [90, 38, 3, 64],
         [93, 49, 3, 42], [58, -4, 7, 4]]
        else
        [[27, 1, 30, 6], [23, 7, 41, 3], [19, 10, 48, 6],
         [17, 6, 55, 5], [17, 21, 55, 28], [13, 19, 4, 30],
         [2, 93, 85, 25], [5, 80, 81, 93], [14, 39, 59, 31],
         [8, 52, 6, 17], [72, 49, 8, 20], [80, 52, 4, 16],
         [72, 25, 5, 24], [7, 72, 6, 9], [72, 69, 6, 11]]
       end
      boxes.collect { |el| box_for(el[0] + @x, el[1] + @y, el[2], el[3]) }
  end

  private

  def box_for(x, y, width, height)
    [x, x + width, y,  y + height]
  end
end
