local Enemy = {}
Enemy.__index = Enemy

local Mobile = require "mobile"
setmetatable(Enemy, Mobile)

require("aphrodisiacs/utils/vector")
require("aphrodisiacs/utils/mathExtension")
require("aphrodisiacs/collisions/hitbox")

local size = 0.333 * tileWidth

local enemySkin = {
    bodyColor = { 160, 40, 160 },
}
function enemySkin:draw()
    love.graphics.setColor(self.bodyColor)
    love.graphics.circle('fill', 0, 0, size, 30)
end


function Enemy.new( x, y )
    x, y = x or 0, y or 0
    
    local new = Mobile.new(x, y, enemySkin, 2 * size, 2 * size)

    -- randomize enemies params
    new.maxSpeed = math.clamp( 600 + love.math.randomNormal(100, 0), 400, 800 )
    new.trSmooth = new.trSmooth * math.clamp( love.math.randomNormal(0.3, 1), 0.7, 1.3 )
    new.rotSmooth = new.rotSmooth * math.clamp( love.math.randomNormal(0.1, 1), 0.8, 1.2 )
    
    return setmetatable(new, Enemy)
end

function Enemy:update( dt, player, world )
    local targetVel = (player.pos - self.pos):normalized() * self.maxSpeed
    local targetRot = (player.pos - self.pos):angle() + math.pi * 0.5

    self:smoothMove( world, dt, targetVel, targetRot )
end

return Enemy
