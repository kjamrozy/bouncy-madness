require_relative 'objects/projectiles/whirl_projectile'
require_relative 'helpers/object_helper'

# player class
class Player
  include ObjectHelper
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

    @img = Gosu::Image.new('media/images/character.png')
    @x = params[:x] || Integer(@scene.width/2 - @img.width/2)
    @y = params[:y] || @scene.height - @img.height
  end

  def draw
    @img.draw(@x, @y, 1, @scale, @scale)
  end

  def update(interval)
    @mov = 0
    @mov = -1 if Gosu.button_down? Gosu::KbLeft
    @mov = 1 if Gosu.button_down? Gosu::KbRight
    @x += interval * @velocity * @mov
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
end
