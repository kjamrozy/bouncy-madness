# base object class, not meant to be instantized
class BaseObject
  attr_accessor :keep
  def initialize(scene, params = {})
    @scene = scene

    @scale = params[:scale] || 1.0
    @x = params[:x] || 0
    @y = params[:y] || 0
    @z = params[:z] || 0
    @color = Gosu::Color.rgba(255, 255, 255, 255)

    @vx = params[:x_velocity] || 0.0
    @vy = params[:y_velocity] || 0.0
    @a  = params[:acceleration] || 0.001 # gravity acceleration

    @min_y = params[:min_y] || 0
    @min_x = params[:min_x] || 0
    @max_y = params[:max_y] || @scene.height
    @max_x = params[:max_x] || @scene.width

    @keep = true
  end

  def draw
    @img.draw(@x, @y, @z, @scale, @scale, @color)
  end

  def update(interval)
    @y = [@max_y, [@min_y, @y + @vy * interval + @a * interval**2 / 2].max].min
    @vy += @a * interval
  end

  def keep?
    @keep
  end

  def to_be_destroyed?
    !keep?
  end
end