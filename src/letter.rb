# Obiekt reprezentujący literke. Posiada biały kolor.
class Letter
  # inicjalizuje obiekt
  def initialize(scene, letter, x, y, height)
    @scene = scene
    @img = Gosu::Image.from_text(letter, height, width: height, align: :center)
    @x = x
    @y = y
  end

  # rysuje literke
  def draw
    @img.draw(@x, @y, 2)
  end

  # zmienia kolor literki na losowy
  def change_color
    @color = Gosu::Color.rgb(rand * 255, rand * 255, rand * 255)
  end

  # zmienia kolor z pewnym prawdopodobieństwem
  def update
    change_color if rand > 0.99
  end
end
