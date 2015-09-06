require_relative 'projectile'

# Line projectione
class LineProjectile < Projectile
  def initialize(scene, params = {})
    super(scene, params)

    @tip_img = Gosu::Image.new('media/images/tip.png')
    @line_img = Gosu::Image.new('media/images/line.png')
    @vy = 0.35
    @x = scene.player.img.width/2 + scene.player.x - 7
    @y = 600 - scene.player.img.height - @tip_img.height
  end

  def draw
    @tip_img.draw(@x, @y, @z)
    @top = @y + @tip_img.height
    while @top <= 600 - @line_img.height
      @line_img.draw(@x, @top, @z)
      @top += @line_img.height
    end
  end

  def update(interval)
    super(interval)
    @keep = false if @y <= 0
  end

  def cbox
    [@x, @x + 15, @y, 600]
  end
end