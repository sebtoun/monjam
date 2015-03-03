local Player = {}
Player.__index = Player

local rnd = love.math.random
local maxColorRnd = 64

require("aphrodisiacs/utils/vector")
require("aphrodisiacs/utils/mathExtension")

function Player.new()
	local new = {
		pos = Vector.new(),
		vel = 100
	}
	new.bodyColor = { 127 + rnd(0, maxColorRnd), 64 + rnd(0, maxColorRnd), 64 + rnd(0, maxColorRnd) }
	new.headColor = { 127 + rnd(0, maxColorRnd), 64 + rnd(0, maxColorRnd), 64 + rnd(0, maxColorRnd) }
	return setmetatable(new, Player)
end

function Player:draw()
	local height, width = 20, 40

	love.graphics.push()
	love.graphics.translate(self.pos.x, self.pos.y)
	love.graphics.rotate(self.rot)
	
	-- body
	love.graphics.setColor(self.bodyColor)
	love.graphics.rectangle('fill', -width / 2, -height / 2, width, height)
	-- head
	love.graphics.setColor(self.headColor)
	love.graphics.circle('fill', 0, 0, 11, 10)

	love.graphics.pop()
end

function Player:update(dt, inputs)
	if inputs.dir then
		local targetPos = self.pos + inputs.dir * self.vel * dt
		self.pos = targetPos
	end
	if inputs.target then
		local targetRot = (inputs.target - self.pos):angle() + math.pi * 0.5
		self.rot = targetRot
	end
end

return Player
