# Obiekt służący do debugowania. Sprawia, że na ekranie pojawia się kwadrat o losowym kolorze, który znika po 1s.
class Shadow
  def initialize(box)
    @red = Integer(rand * 255)
    @green = Integer(rand * 255)
    @blue = Integer(rand * 255)
    @alpha = 255.0
    @box = box
    @keep = true
  end

  # rysuje kwadrat
  def draw
    fcolor = Gosu::Color.rgba(@red, @green, @blue, @alpha)
    Gosu.draw_quad(
      @box[0], @box[2], fcolor,
      @box[1], @box[2], fcolor,
      @box[1], @box[3], fcolor,
      @box[0], @box[3], fcolor, 4)
  end

  # wylicza stopnień zanikania kwadratu
  def update(interval)
    puts interval
    puts @alpha
    @alpha -= 255.0/1000*interval
    @keep = false if @alpha <= 0
  end

  # informuje czy obiekt powinien wciąż znajdować się na scenie
  def keep?
    @keep
  end

  # informuje czy usunąć obiekt, ze sceny
  def to_be_destroyed?
    !keep?
  end
end