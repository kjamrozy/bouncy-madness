require_relative 'player'
require_relative 'objects/hostile/ball'
require_relative 'objects/projectiles/projectile'
require_relative 'objects/debug/shadow'

# GameScene class is in charge of holding objects which appear on the screen
class GameScene
  attr_reader :objects, :player, :width, :height
  def initialize(context)
    @window = context
    @width = @window.width
    @height = @window.height
    @objects = []
    @player = Player.new(self, 0, 520)
    @background = Gosu::Image.new('media/images/background.png')
    @count_of = Hash.new(0)
  end
  
  def draw
    @background.draw(0, 0, -1)
    @objects.each(&:draw)
    @player.draw
  end

  def update(interval)
    exit if Gosu.button_down? Gosu::KbEscape

    @player.mov = 0
    @player.mov = -1 if Gosu.button_down? Gosu::KbLeft
    @player.mov = 1 if Gosu.button_down? Gosu::KbRight

    @objects.each { |obj| obj.keep? && collisions(obj) }
    @objects.each { |obj| obj.keep? && obj.update(interval) }
    @objects.keep_if do |obj|
      obj.keep? || (@count_of[obj.class.name] -= 1) && false
    end

    @player.update(interval)

    @player.shot if Gosu.button_down?(Gosu::KbSpace) && @player.cooldown?

    # random events
    if rand * 100 > 99 && @count_of[Ball.name] < 3
      radius = rand * 45 + 5
      y = [rand * 600 - 2 * radius - @player.img.height, 1].max
      add_object(Ball.new(self, radius: radius, y: y))
    end
  end

  def add_object(obj)
    @count_of[obj.class.name] += 1
    @objects.push(obj)
  end

  def collisions(obj1)
    if obj1.is_a?(Projectile) && obj1.keep?
      @objects.keep_if do |obj2|
        next true if obj1 == obj2 || obj2.to_be_destroyed?
        if obj2.is_a?(Ball) && boxes_intersects?(obj1.cbox, obj2.cbox)
          obj2.pop
          # add_object(Shadow.new(obj1.cbox))
          # add_object(Shadow.new(obj2.cbox))
          get_rid_of(obj1, obj2)
          @player.cooldown = Time.now + 0.1 # reset cooldown as a bonus
          break
        end
        true
      end
    end
    true
  end

  def boxes_intersects?(b1, b2)# [x1, x2, y1, y2]
    (b1[1] > b2[0]) && (b1[0] < b2[1]) && (b1[3] > b2[2]) && (b1[2] < b2[3])
  end

  def get_rid_of(*objs)
    objs.each do |obj|
      @count_of[obj.class.name] -= 1
      obj.keep = false
    end
  end
end
