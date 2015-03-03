Player = require("Player")
require("aphrodisiacs/utils/vector")

function love.load(arg)
	player = Player.new()
end

function love.keypressed(key, isrepeat)
	if (key == 'escape') then
		love.event.quit()
	end
end

function love.update(dt)
	inputs = { 
		dir = Vector.new(),
		target = Vector.new(love.mouse.getPosition()) 
	}

	if love.keyboard.isDown('q') then
		inputs.dir = inputs.dir + Vector.left
	end

	if love.keyboard.isDown('d') then
		inputs.dir = inputs.dir + Vector.right
	end
	
	if love.keyboard.isDown('z') then
		inputs.dir = inputs.dir + Vector.up
	end
	
	if love.keyboard.isDown('s') then
		inputs.dir = inputs.dir + Vector.down
	end
	
	if (inputs.dir.x > 0 or inputs.dir.y > 0) then 
		inputs.dir = inputs.dir:normalized()
	end
	player:update(dt, inputs)
end

function love.draw()
	player:draw()
end
