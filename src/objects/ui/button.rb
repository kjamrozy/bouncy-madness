require_relative '../../game_constants'

# Button. Przycisk, posiada pozycje, tekst i akcje, która jest wykonywana po kliknięciu.
class Button
  include GameConstants
  NORMAL = 0
  HOVER = 1
  DOWN = 2
  UP = 3
  # Inicjalizacja przycisku
  def initialize(scene, text, x, y, width, height)
    @scene = scene
    @width = width
    @height = height
    @x1 = x.to_i
    @y1 = y.to_i
    @x2 = (x + width).to_i
    @y2 = (y + height).to_i
    @z = HUD

    @on_click = []
    @state = NORMAL
    @text_img = Gosu::Image.from_text(text, height.to_i, width: width, align: :center)
  end

  # Rysuje przycisk na scenie
  def draw
    bg_col =
      if @state == HOVER
        Gosu::Color.rgba(255, 255, 255, 100)
      elsif @state == DOWN
        Gosu::Color.rgba(255, 255, 0, 100)
      else
        Gosu::Color.rgba(0, 0, 0, 100)
      end
    Gosu.draw_quad(@x1, @y1, bg_col, @x2, @y1, bg_col, @x2, @y2, bg_col, @x1, @y2, bg_col, @z)
    @text_img.draw(@x1, @y1, @z, 1.0, 1.0)
  end

  # Dodaje callback na kliknięcie w przycisk.
  def on_click(&block)
    @on_click.push(block)
  end

  # Uaktualnia przycisk
  def update
    x = @scene.window.mouse_x
    y = @scene.window.mouse_y
    return @state = NORMAL unless x.between?(@x1, @x2) && y.between?(@y1, @y2)
    @state = HOVER if @state == NORMAL
    if Gosu.button_down? Gosu::MsLeft
      @state = DOWN
    elsif @state == DOWN
      @on_click.each(&:call)
      @state = HOVER
    end
  end
end
