require 'gosu'
require 'singleton'
require_relative 'menu_scene'


# Obiekt - główne okno aplikacji. Posiada scene, która jest aktualnie wyświetlana. Sceną tą może być menu główne lub rozgrywka. Jest to wzorzec projektowy Singleton.
class Game < Gosu::Window
  include Singleton
  attr_accessor :cursor
  attr_accessor :scene

  # inicjalizuje obiekt, podając rozdzielczość, nazwę okna oraz inicując scenę głównego menu
  def initialize
    super(800, 600)
    self.caption = 'BOUNCY MADNESS'

    @scene = MenuScene.new(self)
    @cursor = true
  end

  # rysuje okno
  def draw
    @scene.draw
  end

  # funkcja służąca do uaktualnia obiektów na scenie
  def update
    @scene.update(update_interval)
  end

  # funkcja która informuje czy wyświetlać kursor
  def needs_cursor?
    @cursor
  end
end
