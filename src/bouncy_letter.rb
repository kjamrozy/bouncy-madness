require_relative 'title_letter'

# bouncing letter 
class BouncyLetter < TitleLetter
  def initialize(scene, letter, x, y, height)
    super(scene, letter, x, y, height)
    @a = 0.001
    @vy = 0
    @dy = - rand * height
    @height = height
    @active = true
  end

  def draw
    @img.draw(@x, @y + @dy, 2, 1.0, 1.0, @color)
  end

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
