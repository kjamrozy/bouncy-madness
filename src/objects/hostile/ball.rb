# ball class
class Ball
  def initialize(scene, params = {})
    @scene = scene

    # initial position, direction and velocity
    @r  = params[:radius] || 50
    @x  = params[:x] || 2 * @r
    @y  = params[:y] || 0
    @vx = params[:x_velocity] || 0.1
    @vy = params[:y_velocity] || 0.0
    @a  = params[:acceleration] || 0.001 # gravity acceleration

    # ball behaviour
    @vsize = params[:vanishing_size] || 5

    # boundaries of screen
    @min_y = params[:min_y] || 0
    @min_x = params[:min_x] || 0
    @max_y = params[:max_y] || 600 - 2 * @r
    @max_x = params[:max_x] || 800 - 2 * @r

    @img = Gosu::Image.new('media/images/ball.png')
  end

  def draw
    x_scale = 2 * @r.to_f / @img.width
    y_scale = 2 * @r.to_f / @img.height.to_f
    @img.draw(@x, @y, 1, x_scale, y_scale)
  end

  # current ball splits into two smaller balls
  def pop
    return true unless @r > @vsize

    new_ball_params =
      { radius: @r / 2, x: @x + @r / 2, y: @y + @r / 2,
        x_velocity: @vx, vanishing_size: @vsize }
    # add two smaller new balls
    @scene.add_object(Ball.new(@scene, new_ball_params))
    new_ball_params[:x_velocity] = -@vx
    @scene.add_object(Ball.new(@scene, new_ball_params))
  end

  def update(interval)
    return pop && false if @y == @min_y

    @y = [@max_y, [@min_y, @y + @vy * interval + @a * interval**2 / 2].max].min
    @vy += @a * interval
    @x = [@max_x, [@min_x, @x + @vx * interval].max].min
    @vy = -@vy if @y == @max_y
    @vx = -@vx if @x == @max_x || @x == @min_x
    true
  end
end
