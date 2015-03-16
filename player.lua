local Player = {}
Player.__index = Player

local Mobile = require "mobile"
setmetatable(Player, Mobile)

require("aphrodisiacs/utils/vector")
require("aphrodisiacs/utils/mathExtension")
require("aphrodisiacs/collisions/hitbox")

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

    local new = Mobile.new(x, y, playerSkin, 2 * size, 2 * size)
    new.maxSpeed = 800
    
    cursor = love.graphics.newImage( "assets/cursor.png" )
    cursorColor = { 207, 67, 67 }

    return setmetatable(new, Player)
end

function Player:update( dt, inputs, world )
    local targetVel = inputs.dir * self.maxSpeed
    local targetRot = (inputs.target - self.pos):angle() + math.pi * 0.5

    self:smoothMove( world, dt, targetVel, targetRot )
end

return Player
