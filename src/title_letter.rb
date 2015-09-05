require_relative 'letter'

# letter which changes colors randomly
class TitleLetter < Letter
  def initialize(scene, letter, x, y, height)
    super(scene, letter, x, y, height)
    change_color
  end

  def draw
    @img.draw(@x, @y, 2, 1.0, 1.0, @color)
  end

  def update
    super
    change_color if rand > 0.99
  end

  private

  def change_color
    @color = Gosu::Color.rgb(rand * 255, rand * 255, rand * 255)
  end
end
