local Player = {}
Player.__index = Player

local Object = require "object"
setmetatable(Player, Object)

require("aphrodisiacs/utils/vector")
require("aphrodisiacs/utils/mathExtension")
require("aphrodisiacs/collisions/hitbox")

local rotSmooth = 0.1
local trSmooth = 0.12

local height, width = 0.333 * tileWidth, 0.8 * tileWidth

local cos, sin, abs = math.cos, math.sin, math.abs

local playerSkin = {
    bodyColor = { 160, 40, 40 },
    headColor = { 239, 208, 207 }
}
function playerSkin:draw()
    -- body
    love.graphics.setColor(self.bodyColor)
    love.graphics.rectangle('fill', -width / 2, -height / 2, width, height)
    -- head
    love.graphics.setColor(self.headColor)
    love.graphics.circle('fill', 0, 0, height / 2 * 1.1, 20)
end


function Player.new( x, y )
    x, y = x or 0, y or 0
    local size = math.min( width, height )

    local new = Object.new(x, y, playerSkin, 2 * size, 2 * size)
    new.maxSpeed = 800
    new.vel = Vector.new()
    new.acc = Vector.new()
    new.angularVel = 0

    cursor = love.graphics.newImage( "assets/cursor.png" )
    cursorColor = { 207, 67, 67 }

    return setmetatable(new, Player)
end

function Player:update( dt, inputs, world )
    -- smooth velocity
    local targetVel = inputs.dir * self.maxSpeed
    self.vel.x, self.acc.x = math.smoothDamp(self.vel.x, targetVel.x, self.acc.x, trSmooth, math.huge, dt)
    self.vel.y, self.acc.y = math.smoothDamp(self.vel.y, targetVel.y, self.acc.y, trSmooth, math.huge, dt)
    
    -- move position
    self:move( self.vel * dt )

    -- check collisions
    local disp = world:checkCollisionsWithWalls( self.hitbox.min, self.hitbox.max )
    if disp then 
        self:move( disp )
    end

    -- smooth rotation
    local targetRot = (inputs.target - self.pos):angle() + math.pi * 0.5
    self.rot, self.angularVel = math.smoothDampAngle(self.rot, targetRot, self.angularVel, rotSmooth, math.huge, dt)
end

return Player
