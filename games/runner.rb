require 'gosu'

class RunningHeroWindow < Gosu::Window
	def initialize 
		super(960, 480)
		self.caption = "Running Hero Game"
		
		@hero = Gosu::Image.new("assets/hero.png")
		@background = Gosu::Image.new("assets/background.png")
		@hero_position = [50, 348]
		@hero_direction = :right
	
	end
	
	def update
		if Gosu::button_down?(Gosu::KbRight)
			move(:right)
		elsif Gosu::button_down?(Gosu::KbLeft)
			move(:left)
		end
		
		jump if Gosu::button_down?(Gosu::KbSpace)
		handle_jump if @jumping
	end
	
	def jump
		return if @jumping
		@jumping = true
		@vertical_velocity = 30
	end
	
	def handle_jump
	gravity = 1.75
	ground_level = 348
	@hero_position = [@hero_position[0], @hero_position[1]- @vertical_velocity]
	
	if @vertical_velocity.round == 0
			@vertical_velocity = -1
		elsif @vertical_velocity < 0 #falling
			@vertical_velocity = @vertical_velocity * gravity
		else
			@vertical_velocity = @vertical_velocity / gravity
		end
		
		if @hero_position[1] >= ground_level
			@hero_position[1] = ground_level
			@jumping = false
		end
		
	
	end
	
	def move(way)
		speed = 5
		if way == :right
			@hero_position[0] += speed
			@hero_direction = :right
		else
			@hero_position[0] -= speed
			@hero_direction = :left
		end
	end
	
	def draw
		@background.draw(0,0,0)
		@hero.draw(@hero_position[0], @hero_position[1], 1)
		z = 1
		x,y = @hero_position
		if @hero_direction == :right
			@hero.draw(x,y,z)
		else
			@hero.draw(x + @hero.width, y,z,-1)
		end
	end

end

RunningHeroWindow.new.show