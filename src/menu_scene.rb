require_relative 'objects/ui/button'
require_relative 'game_scene'
require_relative 'bouncy_letter'
require_relative 'game_constants'
# main menu screen
class MenuScene
  include GameConstants
  attr_reader :window
  def initialize(context)
    @window = context

    @new_game_btn = Button.new(self, 'Play', 250, 300, 300, 50)
    @new_game_btn.on_click { @window.scene = GameScene.new(@window) }

    @highscores_btn = Button.new(self, 'Highscores', 250, 400, 300, 50)

    @exit_btn = Button.new(self, 'Exit', 250, 500, 300, 50)
    @exit_btn.on_click { exit }
  end

  def draw
    @background.draw(0, 0, BACKGROUND)
    draw_btns
    draw_title
  end

  def draw_btns
    @new_game_btn.draw
    @highscores_btn.draw
    @exit_btn.draw
  end

  def draw_title
    @letters.each(&:draw)
    @underscores.each(&:draw)
  end

  def update(interval)
    load_assets
    update_btns
    update_title(interval)
  end

  def update_btns
    @new_game_btn.update
    @highscores_btn.update
    @exit_btn.update
  end

  def update_title(interval)
    @letters.each { |el| el.update(interval) }
    @underscores.each(&:update)
  end

  def load_assets
    @background ||= Gosu::Image.new('media/images/main_background.png')
    @letters ||= 'BOUNCY MADNESS'.split('').each.with_index.collect  do |l, i|
      BouncyLetter.new(self, l, 25 + 50 * i, 100, 100)
    end
    @underscores ||= (['_'] * 14).each.with_index.collect do |l, i|
      TitleLetter.new(self, l, 25 + 50 * i, 100, 100)
    end
  end
end
