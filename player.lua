local Player = {}
Player.__index = Player

local rnd = love.math.random()
local maxColorRnd = 64

require("aphrodisiacs/utils/vector")
	
function Player.new()
	local new = { pos = Vector.new }
	new.bodyColor = { 127 + rnd(0, maxColorRnd), 64 + rnd(0, maxColorRnd), 64 + rnd(0, maxColorRnd) }
	new.headColor = { 127 + rnd(0, maxColorRnd), 64 + rnd(0, maxColorRnd), 64 + rnd(0, maxColorRnd) }
	return setmetatable(new, Player)
end

function Player:draw()
	local height, width = 10, 20
	-- body
	love.graphics.setColor(self.bodyColor)
	love.graphics.rectangle('fill', -width / 2, -height / 2, width, height)
	-- head
	love.graphics.setColor(self.headColor)
	love.graphics.circle('fill', 0, 0, 6, 12)
end

function Player:update(dt, inputs)
	if inputs.dir then
		self.x, self.y = 
	end
end

return Player