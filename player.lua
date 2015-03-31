local Player = {}
Player.__index = Player

local Mobile = require "mobile"
setmetatable(Player, Mobile)

require("aphrodisiacs/utils/vector")
require("aphrodisiacs/utils/mathExtension")
require("aphrodisiacs/collisions/hitbox")

local Equipment = require("Equipment")

local height, width = 0.333 * tileWidth, 0.8 * tileWidth

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


function Player.new( x, y, world )
    x, y = x or 0, y or 0
    local size = math.min( width, height )

    local new = Mobile.new(x, y, playerSkin, 2 * size, 2 * size)
    new.maxSpeed = 800
    new.world = world
    new.equipment = { Equipment.Sword( 'right', new, world ) }

    return setmetatable(new, Player)
end

function Player:update( dt, inputs )
    local targetVel = inputs.dir * self.maxSpeed
    local targetRot = (inputs.target - self.pos):angle() + math.pi * 0.5

    self:smoothMove( dt, targetVel, targetRot )

    for _, e in pairs(self.equipment) do
        e:update( dt, inputs )
    end
end

function Player:draw()
    Mobile.draw(self)
    
    -- equipment
    for _, e in pairs(self.equipment) do
        e:draw()
    end
end

return Player
