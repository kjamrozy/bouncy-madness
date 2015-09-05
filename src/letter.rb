# basic letter object
class Letter
  def initialize(scene, letter, x, y, height)
    @scene = scene
    @img = Gosu::Image.from_text(letter, height, width: height, align: :center)
    @x = x
    @y = y
  end

  def draw
    @img.draw(@x, @y, 2)
  end

  def change_color
    @color = Gosu::Color.rgb(rand * 255, rand * 255, rand * 255)
  end

  def update
    change_color if rand > 0.99
  end
end
