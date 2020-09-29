class PlayState < GameState
  attr_accessor :update_interval

  def initialize
    # http://www.paulandstorm.com/wha/clown-names/
    @names = Names.new(
      Utils.media_path('names.txt'))
    @object_pool = ObjectPool.new(Map.bounding_box)
    @map = Map.new(@object_pool)
    @map.spawn_points(100)
    @camera = Camera.new
    @tank = Tank.new(@object_pool,
      PlayerInput.new('Player', @camera, @object_pool))
    @camera.target = @tank
    @object_pool.camera = @camera
    @radar = Radar.new(@object_pool, @tank)
    30.times do |i|
      Tank.new(@object_pool, AiInput.new(
        @names.random, @object_pool))
    end
    puts "Pool size: #{@object_pool.size}"
  end

  def update
    StereoSample.cleanup
    @object_pool.update_all
    @camera.update
    @radar.update
    update_caption
  end

  def draw
    cam_x = @camera.x
    cam_y = @camera.y
    off_x =  $window.width / 2 - cam_x
    off_y =  $window.height / 2 - cam_y
    viewport = @camera.viewport
    x1, x2, y1, y2 = viewport
    box = AxisAlignedBoundingBox.new(
      [x1 + (x2 - x1) / 2, y1 + (y2 - y1) / 2],
      [x1 - Map::TILE_SIZE, y1 - Map::TILE_SIZE])
    $window.translate(off_x, off_y) do
      zoom = @camera.zoom
      $window.scale(zoom, zoom, cam_x, cam_y) do
        @map.draw(viewport)
        @object_pool.query_range(box).map do |o|
          o.draw(viewport)
        end
      end
    end
    @camera.draw_crosshair
    @radar.draw
  end

  def button_down(id)
    if id == Gosu::KbQ
      leave
      $window.close
    end
    if id == Gosu::KbEscape
      GameState.switch(MenuState.instance)
    end
    if id == Gosu::KbT
      t = Tank.new(@object_pool,
        AiInput.new(@names.random, @object_pool))
      t.x, t.y = @camera.mouse_coords
    end
    if id == Gosu::KbF1
      $debug = !$debug
    end
    if id == Gosu::KbF2
      toggle_profiling
    end
    if id == Gosu::KbR
      @tank.mark_for_removal
      @tank = Tank.new(@object_pool,
        PlayerInput.new('Player', @camera, @object_pool))
      @camera.target = @tank
      @radar.target = @tank
    end
  end

  def leave
    StereoSample.stop_all
    if @profiling_now
      toggle_profiling
    end
    puts "Pool: #{@object_pool.size}"
  end

  private

  def toggle_profiling
    require 'ruby-prof' unless defined?(RubyProf)
    if @profiling_now
      result = RubyProf.stop
      printer = RubyProf::FlatPrinter.new(result)
      printer.print(STDOUT, min_percent: 0.01)
      @profiling_now = false
    else
      RubyProf.start
      @profiling_now = true
    end
  end

  def update_caption
    now = Gosu.milliseconds
    if now - (@caption_updated_at || 0) > 1000
      $window.caption = 'Tanks Prototype. ' <<
        "[FPS: #{Gosu.fps}. " <<
        "Tank @ #{@tank.x.round}:#{@tank.y.round}]"
      @caption_updated_at = now
    end
  end
end
