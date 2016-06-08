require_relative 'player'
require_relative 'ui'
require_relative 'objects/hostile/ball'
require_relative 'objects/projectiles/projectile'
require_relative 'objects/powerups/powerups'
require_relative 'game_constants'
require_relative 'objects/debug/shadow'

# Obiekt będący sceną rozgrywki. Odpowiada za zarządzanie obiektami które pojawiają się na scenie.
class GameScene
  include GameConstants
  attr_reader :objects, :player, :width, :height,
              :state, :window, :frozen
  attr_accessor :score
  def initialize(context)
    @window = context
    @width = @window.width
    @height = @window.height
    #special var for checking if balls should move
    @frozen = Gosu.milliseconds - 1

    new_game
    
    @ui = UI.new(self)

    @background = Gosu::Image.new('media/images/background.png')
  end

  # Inicjuje nową grę.
  def new_game
    @player = Player.new(self)
    @objects = []

    @score = 0
    @last_update = Gosu.milliseconds
    @count_of = Hash.new(0)
    @state = 'ACTIVE'
  end

  # Rysuje scenę.
  def draw
    @background.draw(0, 0, BACKGROUND)
    @objects.each(&:draw)
    @player.draw
    @ui.draw
  end

  # Uaktualnia obiekty na scenie.
  def update(interval)
    seconds = Gosu.milliseconds
    interval = seconds - @last_update
    @last_update = seconds

    exit if Gosu.button_down? Gosu::KbEscape
    10.times do |i|
      next unless Gosu.button_down?(Gosu::Kb1+i) && @player.powerups[i]
      @player.powerups[i].invoke
    end

    @state = 'PAUSE' if Gosu.button_down? Gosu::KbP
    @state = 'ACTIVE' if (Gosu.button_down?(Gosu::KbEnter) || Gosu.button_down?(Gosu::KbReturn)) && @state == 'PAUSE'

    @ui.update(seconds)
    return unless @state == 'ACTIVE'

    @objects.each { |obj| obj.keep? && collisions(obj) }
    @objects.each { |obj| obj.keep? && obj.update(interval) }
    @objects.keep_if do |obj|
      obj.keep? || (@count_of[obj.class.name] -= 1) && false
    end

    @player.update(interval)

    @player.shot if Gosu.button_down?(Gosu::KbSpace) && @player.cooldown?
    # random events
    if rand * 100 > 95 && @count_of[Ball.name] < 3
      radius = rand * 45 + 5
      y = [rand * @height - 2 * radius - @player.img.height - 20, 10].max
      x = rand * (@width - 2 * radius)
      add_object(Ball.new(self, radius: radius, x: x, y: y))
    end
  end

  # Dodaje obiekt na scenę.
  def add_object(obj)
    @count_of[obj.class.name] += 1
    @objects.push(obj)
  end

  # Oblicza kolizje na scenie.
  def collisions(obj)
    return projectile_collisions(obj) if obj.is_a?(Projectile) && obj.keep?
    return powerup_collision(obj) if obj.is_a?(Powerup)
    return unless obj.is_a?(Ball) && obj.keep?
    player_collision(obj)
    #balls_collisions(obj)
  end

  # Zatrzymuje obiekty na scenie(oprócz gracza).
  def freeze(time)
    @frozen = Gosu.milliseconds + time
  end

  # Informuje czy scena jest zamrożona.
  def frozen?
    @frozen >= Gosu.milliseconds
  end

  # Obsługuje ew. kolizje kulki z graczem.
  def player_collision(ball)
    return if @player.rainbow > 0
    return unless @player.cbox.any? { |cbox| boxes_intersect?(cbox, ball.cbox) }
    @player.shield = 255 if @player.shield > 255
    return if @player.shield > 0
    @state = 'GAME_OVER'
  end

  # Obsługuje kolizje pocisku z kulkami.
  def projectile_collisions(proj)
    @objects.each do |obj|
      next if proj == obj || obj.to_be_destroyed?
      next unless obj.is_a?(Ball) && boxes_intersect?(proj.cbox, obj.cbox)
      obj.pop
      get_rid_of(proj, obj)
      @player.cooldown = Gosu.milliseconds + 100 # reset cooldown as a bonus
      break
    end
  end

  # Obsługuje kolizje gracza z powerupami.
  def powerup_collision(pow)
    return unless @player.cbox.any? { |b| boxes_intersect?(b, pow.cbox) }
    @player.powerups[pow.id] = pow
    pow.keep = false
  end

  # Informuje czy dwa prostokąty się przecinają.
  def boxes_intersect?(b1, b2) # [x1, x2, y1, y2]
    (b1[1] > b2[0]) && (b1[0] < b2[1]) && (b1[3] > b2[2]) && (b1[2] < b2[3])
  end

  # Usuwa obiekt ze sceny
  def get_rid_of(*objs)
    objs.each { |obj| obj.keep = false }
  end
end
