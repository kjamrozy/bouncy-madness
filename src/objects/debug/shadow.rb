# leaves a random color box for a 1 second
class Shadow
  def initialize(box)
    @red = Integer(rand * 255)
    @green = Integer(rand * 255)
    @blue = Integer(rand * 255)
    @alpha = 255.0
    @box = box
    @keep = true
  end

  def draw
    fcolor = Gosu::Color.rgba(@red, @green, @blue, @alpha)
    Gosu.draw_quad(
      @box[0], @box[2], fcolor,
      @box[1], @box[2], fcolor,
      @box[1], @box[3], fcolor,
      @box[0], @box[3], fcolor, 4)
  end

  def update(interval)
    puts interval
    puts @alpha
    @alpha -= 255.0/1000*interval
    @keep = false if @alpha <= 0
  end

  def keep?
    @keep
  end

  def to_be_destroyed?
    !keep?
  end
end