require_relative 'objects/ui/button'

# UI class
class UI
  def initialize(scene)
    @scene = scene
    @z = 10

    @last_score = 0
    @elapsed = 0
    @fps = 0

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

  def load_powerup_imgs(name)
    [Gosu::Image.new("media/images/#{name}_powerup_disabled.png"),
     Gosu::Image.new("media/images/#{name}_powerup.png")]
  end

  def load_powerups_imgs
    @powerups_imgs = (['whirl'] * 10).collect { |name| load_powerup_imgs(name) }
  end

  def draw
    @fps += 1
    pause_notice if @scene.state == 'PAUSE'
    game_over if @scene.state == 'GAME_OVER'
    show_score
    show_fps
    show_powerup_slots
  end

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

  def draw_powerup_slot(x, y, img, params = {})
    x1 = x
    x2 = x + @scene.width * 0.05
    y1 = y
    y2 = y + @scene.width * 0.05
    params.merge!(scale: @scene.width * 0.05 / img.width)
    draw_window(x, y, x1, x2, y1, y2, img, params)
  end

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

  # loads game over buttons
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

  def show_powerup_slots
    10.times do |i|
      x = @scene.width * 0.01 + i * @scene.width * 0.07
      y = @scene.width * 0.01
      draw_powerup_slot(x, y, @powerups_imgs[i][1], img_color: Gosu::Color.rgba(255, 255, 255, 100))
      @numbers[i].draw(
        @scene.width * 0.025 + i * @scene.width * 0.07 , @scene.width * 0.015, @z,
        1.0, 1.0, Gosu::Color::BLACK)
    end
  end

  def update(interval)
    @elapsed += interval
    load_fps_img && (@fps = 0) && (@elapsed = 0) if @elapsed >= 1000
    (@last_score = @scene.score) && load_score_img if @scene.score != @last_score
    if @scene.state == 'GAME_OVER'
      @no_button && @no_button.update
      @yes_button && @yes_button.update 
    end    
  end

  def load_fps_img
    @fps_img = Gosu::Image.from_text(
      'FPS: ' + @fps.to_s, Integer(@scene.height * 0.03),
      align: :center, width: Integer(@scene.width * 0.07))
  end

  def load_score_img
    text = format(
      '%010d', @scene.score).insert(7, '-').insert(4, '-').insert(1, '-')
    @score_img = Gosu::Image.from_text(
      text, Integer(@scene.height * 0.03),
      align: :center, width: Integer(@scene.width * 0.13))
  end

  def pause_notice
    x1 = @scene.width * 0.05
    x2 = @scene.width * 0.95
    y1 = @scene.height * 0.45
    y2 = @scene.height * 0.55
    x = @scene.width * 0.075
    y =  @scene.height * 0.46
    draw_window(x, y, x1, x2, y1, y2, @pause_img)
  end

  def show_fps
    x1 = @scene.width * 0.93
    x2 = @scene.width
    y1 = @scene.height * 0.06
    y2 = @scene.height * 0.11
    x = @scene.width * 0.93
    y =  @scene.height * 0.07
    draw_window(x, y, x1, x2, y1, y2, @fps_img)
  end

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
