require_relative 'objects/ui/button'
require_relative 'game_constants'

# Odpowiada za hud i ekran pauzy.
class UI
  include GameConstants
  # Inicjuje interfejs
  def initialize(scene)
    @scene = scene
    @z = HUD

    @last_score = 0
    @last_updated = Gosu.milliseconds
    @fps = 60

    load_fps_img
    load_score_img
    load_powerups_imgs
    @pause_img = Gosu::Image.from_text(
      'Press enter to continue...', Integer(@scene.height * 0.08),
      align: :center, width: Integer(@scene.width * 0.85))
    @game_over_img = Gosu::Image.from_text(
      "GAME OVER \n Continue?", Integer(@scene.height * 0.13),
      align: :center, width: @scene.width)
    @numbers =
      10.times.collect do |i|
        Gosu::Image.from_text(
          ((i + 1) % 10).to_s, Integer(@scene.width * 0.05),
          align: :center)
      end
  end

  # Ładuje obrazek powerupu
  def load_powerup_imgs(name)
    [Gosu::Image.new("media/images/#{name}_powerup_disabled.png"),
     Gosu::Image.new("media/images/#{name}_powerup.png")]
  end

  # Ładuje obrazki powerupów
  def load_powerups_imgs
    names = ['line','whirl'] + (['placeholder'] * 5) + ['rainbow', 'shield', 'freeze']
    @powerups_imgs = names.collect { |name| load_powerup_imgs(name) }
  end

  # Rysuje intefejs
  def draw
    draw_counter if @scene.frozen?
    pause_notice if @scene.state == 'PAUSE'
    game_over if @scene.state == 'GAME_OVER'
    show_score
    show_fps
    show_powerup_slots
  end

  # Rysuje punktacje
  def draw_counter
    Gosu.draw_rect(715, 150, 80, 45, Gosu::Color.rgba(100, 100, 255, 50), 15)
    @counter_img.draw(715, 150, HUD)
  end

  # Rysuje okno
  def draw_window(x, y, x1, x2, y1, y2, img, params = {})
    scale = params[:scale] || 1.0
    bg_col = params[:background_color] || Gosu::Color.rgba(0, 0, 0, 100)
    img_col = params[:img_color] || Gosu::Color::WHITE
    Gosu.draw_quad(
      x1, y1, bg_col,
      x2, y1, bg_col,
      x2, y2, bg_col,
      x1, y2, bg_col, @z)
    img.draw(x, y, @z, scale, scale, img_col)
  end

  # Rysuje slot na powerupa
  def draw_powerup_slot(x, y, img, params = {})
    x1 = x
    x2 = x + @scene.width * 0.05
    y1 = y
    y2 = y + @scene.width * 0.05
    params.merge!(scale: @scene.width * 0.05 / img.width)
    draw_window(x, y, x1, x2, y1, y2, img, params)
  end

  # Rysuje informacje o przegranej
  def game_over
    @scene.window.cursor = true
    x = 0
    y = @scene.height * 0.3
    x1 = 0
    x2 = @scene.width
    y1 = @scene.height * 0.3
    y2 = @scene.height * 0.6
    draw_window(x, y, x1, x2, y1, y2, @game_over_img)

    load_gm_btns unless @no_button && @yes_button

    @no_button.draw
    @yes_button.draw
  end

  # Ładuje licznik punktów
  def load_counter(time)
    left = format('%.2f', (@scene.frozen - time) / 1000.0)
    @counter_img = Gosu::Image.from_text(left.to_s, 50, align: :center)
  end

  # Ładuje przyciski game over(yes/no)
  def load_gm_btns
    @no_button ||= Button.new(

      @scene, 'NO', 0.1 * @scene.width, 0.7 * @scene.height,
      0.3 * @scene.width, 0.1 * @scene.height)
    @no_button.on_click { exit }

    @yes_button ||= Button.new(
      @scene, 'YES', 0.6 * @scene.width, 0.7 * @scene.height,
      0.3 * @scene.width, 0.1 * @scene.height)
    @yes_button.on_click do
      @scene.new_game
      @no_button = nil
    end
  end

  # Pokazuje sloty na powerupy.
  def show_powerup_slots
    10.times do |i|
      x = @scene.width * 0.01 + i * @scene.width * 0.07
      y = @scene.width * 0.01
      j = @scene.player.powerups[i] ? 1 : 0
      draw_powerup_slot(x, y, @powerups_imgs[i][j], img_color: Gosu::Color.rgba(255, 255, 255, 100))
      @numbers[i].draw(
        @scene.width * 0.025 + i * @scene.width * 0.07 , @scene.width * 0.015, @z,
        1.0, 1.0, Gosu::Color::BLACK)
    end
  end

  # Uaktualnia interfejs
  def update(time)
    interval = time - @last_updated
    @last_updated = time

    load_counter(time) if @scene.frozen?
    load_fps_img unless @fps == Gosu.fps
    (@last_score = @scene.score) && load_score_img if @scene.score != @last_score
    if @scene.state == 'GAME_OVER'
      @no_button && @no_button.update
      @yes_button && @yes_button.update 
    end    
  end

  # Ładuje obrazem z fpsami
  def load_fps_img
    @fps = Gosu.fps
    @fps_img = Gosu::Image.from_text(
      'FPS: ' + Gosu.fps.to_s, Integer(@scene.height * 0.03),
      align: :center, width: Integer(@scene.width * 0.07))
  end

  # Ładuje obrazek z punktacją
  def load_score_img
    text = format(
      '%010d', @scene.score).insert(7, '-').insert(4, '-').insert(1, '-')
    @score_img = Gosu::Image.from_text(
      text, Integer(@scene.height * 0.03),
      align: :center, width: Integer(@scene.width * 0.13))
  end

  # Rysuje okiekno pauzy.
  def pause_notice
    x1 = @scene.width * 0.05
    x2 = @scene.width * 0.95
    y1 = @scene.height * 0.45
    y2 = @scene.height * 0.55
    x = @scene.width * 0.075
    y =  @scene.height * 0.46
    draw_window(x, y, x1, x2, y1, y2, @pause_img)
  end

  # Pokazuje liczbe fpsów.
  def show_fps
    x1 = @scene.width * 0.93
    x2 = @scene.width
    y1 = @scene.height * 0.06
    y2 = @scene.height * 0.11
    x = @scene.width * 0.93
    y =  @scene.height * 0.07
    draw_window(x, y, x1, x2, y1, y2, @fps_img)
  end

  # Pokazuje punktacje.
  def show_score
    x1 = @scene.width * 0.85
    x2 = @scene.width
    y1 = 0
    y2 = @scene.height * 0.05
    x = @scene.width * 0.86
    y =  @scene.height * 0.01
    draw_window(x, y, x1, x2, y1, y2, @score_img)
  end
end
