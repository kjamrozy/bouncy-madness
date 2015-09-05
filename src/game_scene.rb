require_relative 'player'
require_relative 'ui'
require_relative 'objects/hostile/ball'
require_relative 'objects/projectiles/projectile'
require_relative 'objects/debug/shadow'

# GameScene class is in charge of holding objects which appear on the screen
class GameScene
  attr_reader :objects, :player, :width, :height, :state, :window
  attr_accessor :score
  def initialize(context)
    @window = context
    @width = @window.width
    @height = @window.height

    new_game
    
    @ui = UI.new(self)

    @background = Gosu::Image.new('media/images/background.png')
  end

  def new_game
    @player = Player.new(self)
    @objects = []

    @score = 0
    @count_of = Hash.new(0)
    @state = 'ACTIVE'
  end

  def draw
    @background.draw(0, 0, -1)
    @objects.each(&:draw)
    @player.draw
    @ui.draw
  end

  def update(interval)
    exit if Gosu.button_down? Gosu::KbEscape
    @ui.update(interval)

    @state = 'PAUSE' if Gosu.button_down? Gosu::KbP
    @state = 'ACTIVE' if (Gosu.button_down?(Gosu::KbEnter) || Gosu.button_down?(Gosu::KbReturn)) && @state == 'PAUSE'

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

  def add_object(obj)
    @count_of[obj.class.name] += 1
    @objects.push(obj)
  end

  def collisions(obj1)
    return projectile_collisions(obj1) if obj1.is_a?(Projectile) && obj1.keep?
    return unless obj1.is_a?(Ball) && obj1.keep?
    player_collision(obj1)
    balls_collisions(obj1)
  end

  def balls_collisions(ball1)
    # not yet implemented(if ever)
  end

  def player_collision(ball)
    return true unless @player.cbox.any? { |cbox| boxes_intersect?(cbox, ball.cbox) }
    @state = 'GAME_OVER'
  end

  def projectile_collisions(proj)
    @objects.each do |obj|
      next if proj == obj || obj.to_be_destroyed?
      next unless obj.is_a?(Ball) && boxes_intersect?(proj.cbox, obj.cbox)
      obj.pop
      get_rid_of(proj, obj)
      @player.cooldown = Time.now + 0.1 # reset cooldown as a bonus
      # add_object(Shadow.new(obj1.cbox))
      # add_object(Shadow.new(obj2.cbox))
      break
    end
  end

  def boxes_intersect?(b1, b2) # [x1, x2, y1, y2]
    (b1[1] > b2[0]) && (b1[0] < b2[1]) && (b1[3] > b2[2]) && (b1[2] < b2[3])
  end

  def get_rid_of(*objs)
    objs.each { |obj| obj.keep = false }
  end
end
