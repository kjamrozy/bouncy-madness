require_relative 'title_letter'

# Obiekt reprezentujący tytułową literke. Dziedziczy po Letter, korzysta z jej funkcji, ale dodaje właśność która sprawia, że literka odbija się od podłoża.
class BouncyLetter < TitleLetter
  # inicjalizuje literkę podając parametry do swojej nadklasy, w celu dziedziczenia pożądanych własności
  def initialize(scene, letter, x, y, height)
    super(scene, letter, x, y, height)
    @a = 0.001
    @vy = 0
    @dy = - rand * height
    @height = height
    @active = true
  end

  # rysuje obiekt na scenie
  def draw
    @img.draw(@x, @y + @dy, 2, 1.0, 1.0, @color)
  end

  # uaktualnia położenie literki
  def update(interval)
    change_color if rand > 0.99

    x = @scene.window.mouse_x
    y = @scene.window.mouse_y
    @active = false if x.between?(@x, @x + @height) && y.between?(@y, @y + @height)

    @dy = [0, @dy + @vy * interval + @a * interval**2 / 2].min
    @vy += @a * interval
    @vy = -@vy if @dy >= 0 && @active
  end
end
