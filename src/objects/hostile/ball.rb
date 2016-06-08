require_relative '../base_object'
require_relative '../../helpers/object_helper'
require_relative '../projectiles/whirl_projectile'
require_relative '../powerups/powerups'

# Kula. Jej rolą jest odbijanie się w odrębie ekranu. Dotknięcie gracza sprawia, że gracz przegrywa(chyba, ze posiada tarczę lub jest w danym momencie nietykalny).
# Posiada prędkość, wspórzędne x,y, obrazek oraz kolor. Dziedziczy po BaseObject. Po rozbiciu kuli, istnieje losowa szansa na pozostawienie powerupa.
class Ball < BaseObject
  include ObjectHelper
  # inicjuje obiekt
  def initialize(scene, params = {})
    super(scene, params)
    @z = BALL
    @r  = params[:radius] || 50
    @vx = params[:x_velocity] || 0.1

    @img = Gosu::Image.new('media/images/ball.png')
    # ball behaviour
    @vsize = params[:vanishing_size] || 10
    @scale = params[:scale] || 2 * @r.to_f / @img.width
    # boundaries of screen
    @max_y = params[:max_y] || @scene.height - 2 * @r
    @max_x = params[:max_x] || @scene.width - 2 * @r
    @color = Gosu::Color.rgba(
      Integer(255 * rand), Integer(255 * rand), Integer(255 * rand), 255)
  end

  # rozbija kule na dwie mniejsze
  def pop
    @scene.score += 1
    @keep = false
    return unless @r > @vsize

    x = @x + @r / 2
    y = @y + @r / 2
    new_ball_params =
      { radius: @r / 2, x: x, y: y,
        x_velocity: @vx, y_velocity: -0.5, vanishing_size: @vsize }
    # add two smaller new balls
    @scene.add_object(Ball.new(@scene, new_ball_params))
    new_ball_params[:x_velocity] = -@vx
    @scene.add_object(Ball.new(@scene, new_ball_params))
    # set 90% chance to drop powerup
    return if rand < 0.3
    @scene.add_object(random_powerup.new(@scene, x: x, y: y))
  end

  # uaktualnia pozycje i prędkośc kuli
  def update(interval)
    return if @scene.frozen?
    return @keep = false if @y == @min_y

    super(interval)
    @x = [@max_x, [@min_x, @x + @vx * interval].max].min
    @vy = -@vy if @y == @max_y
    @vx = -@vx if @x == @max_x || @x == @min_x
  end

  # losuje powerup
  def random_powerup
    [WhirlPowerup, FreezePowerup, ShieldPowerup, RainbowPowerup].sample
  end

end
