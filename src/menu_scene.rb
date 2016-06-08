require_relative 'objects/ui/button'
require_relative 'game_scene'
require_relative 'bouncy_letter'
require_relative 'game_constants'
# Odpowiada za główne menu. Wyświetlane są na nim obiekty takie jak logo. Przyciski nowej gry i wyjścia.
class MenuScene
  include GameConstants
  attr_reader :window
  # inicjaluzuje obiekt, tworząc przyciski nowej gry oraz wyjścia
  def initialize(context)
    @window = context

    @new_game_btn = Button.new(self, 'Play', 250, 300, 300, 50)
    @new_game_btn.on_click { @window.scene = GameScene.new(@window) }

    @exit_btn = Button.new(self, 'Exit', 250, 400, 300, 50)
    @exit_btn.on_click { exit }
  end

  # rysuje scenę
  def draw
    @background.draw(0, 0, BACKGROUND)
    draw_btns
    draw_title
  end

  # rysuje przyciski
  def draw_btns
    @new_game_btn.draw
    #@highscores_btn.draw
    @exit_btn.draw
  end

  # rysuje logo gry
  def draw_title
    @letters.each(&:draw)
    @underscores.each(&:draw)
  end

  # uaktualnia obiekty na scenie
  def update(interval)
    load_assets
    update_btns
    update_title(interval)
  end

  # uaktualnia przyciski
  def update_btns
    @new_game_btn.update
    #@highscores_btn.update
    @exit_btn.update
  end

  # uaktualnia tytuł
  def update_title(interval)
    @letters.each { |el| el.update(interval) }
    @underscores.each(&:update)
  end

  # ładuje obrazki
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
