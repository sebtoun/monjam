local Player = {}
Player.__index = Player

require("aphrodisiacs/utils/vector")
require("aphrodisiacs/utils/mathExtension")

local rnd = love.math.random
local maxColorRnd = 180
local rotSmooth = 0.1
local trSmooth = 0.2

function Player.new()
    local new = {
        pos = Vector.new(),
        maxSpeed = 800,
        vel = Vector.new(),
        acc = Vector.new(),
        rot = 0,
        angularVel = 0
    }
    -- new.bodyColor = { rnd(0, maxColorRnd), rnd(0, maxColorRnd), rnd(0, maxColorRnd) }
    new.bodyColor = { 160, 40, 40 }
    -- new.headColor = { rnd(0, maxColorRnd), rnd(0, maxColorRnd), rnd(0, maxColorRnd) }
    new.headColor = { 239, 208, 207 }

    cursor = love.graphics.newImage( "assets/cursor.png" )
    cursorColor = { 207, 67, 67 }

    return setmetatable(new, Player)
end

function Player:draw()
    local height, width = 40, 100

    love.graphics.push()
    love.graphics.translate(self.pos.x, self.pos.y)
    love.graphics.rotate(self.rot)

    -- body
    love.graphics.setColor(self.bodyColor)
    love.graphics.rectangle('fill', -width / 2, -height / 2, width, height)
    -- head
    love.graphics.setColor(self.headColor)
    love.graphics.circle('fill', 0, 0, height / 2 * 1.1, 20)

    love.graphics.pop()
end

function Player:update(dt, inputs)
    if inputs.dir then
        -- smooth velocity
        local targetVel = inputs.dir * self.maxSpeed
        self.vel.x, self.acc.x = math.smoothDamp(self.vel.x, targetVel.x, self.acc.x, trSmooth, math.huge, dt)
        self.vel.y, self.acc.y = math.smoothDamp(self.vel.y, targetVel.y, self.acc.y, trSmooth, math.huge, dt)
        -- move position
        self.pos = self.pos + self.vel * dt
        -- self.pos = self.pos + targetVel * dt
    end
    if inputs.target then
        -- smooth rotation
        local targetRot = (inputs.target - self.pos):angle() + math.pi * 0.5
        self.rot, self.angularVel = math.smoothDampAngle(self.rot, targetRot, self.angularVel, rotSmooth, math.huge, dt)
        -- self.rot = targetRot
    end
end

return Player
