# Object helper module
module ObjectHelper
  # collision box
  def cbox
    [ @x, @x + @img.width*@scale, @y, @y + @img.height*@scale ]# x1, x2, y1, y2
  end
end