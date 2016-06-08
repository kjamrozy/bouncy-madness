require_relative '../helpers/object_helper'
require_relative '../game_constants'

# BaseObject. Podstawowy obiekt, który pojawia się na ekranie. Posiada współrzędne x,y, z, obrazek. Obcina współrzędne jeśli są poza ekranem, 
class BaseObject
  include ObjectHelper
  include GameConstants
  attr_accessor :keep

  # Rysuje obiekt na scenie
  def draw
    @img.draw(@x, @y, @z, @scale, @scale, @color)
  end

  # Uaktualnia dane obiektu
  def update(interval)
    @y = [@max_y, [@min_y, @y + @vy * interval + @a * interval**2 / 2].max].min
    @vy += @a * interval
  end

  # Czy dalej trzymać obiekt na scenie.
  def keep?
    @keep
  end

  # Czy usunąć obiekt ze sceny
  def to_be_destroyed?
    !keep?
  end

  protected
  # Inicjalizacja, pseudo klasa abstrakcyjna, ponieważ konstruktor jest protected.
  def initialize(scene, params = {})
    @scene = scene

    @scale = params[:scale] || 1.0
    @x = params[:x] || 0
    @y = params[:y] || 0
    @z = params[:z] || 0
    @color = Gosu::Color.rgba(255, 255, 255, 255)

    @vx = params[:x_velocity] || 0.0
    @vy = params[:y_velocity] || 0.0
    @a  = params[:acceleration] || 0.001 # gravity acceleration

    @min_y = params[:min_y] || 0
    @min_x = params[:min_x] || 0
    @max_y = params[:max_y] || @scene.height
    @max_x = params[:max_x] || @scene.width

    @keep = true
  end
end