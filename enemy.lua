local Enemy = {
    all = {}
}
Enemy.__index = Enemy

local Mobile = require "mobile"
local Level = require "level"
setmetatable(Enemy, Mobile)

require("aphrodisiacs/utils/vector")
require("aphrodisiacs/utils/mathExtension")
require("aphrodisiacs/collisions/hitbox")

local size = 0.2 * tileWidth

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
    
    table.insert(Enemy.all, new)

    return setmetatable(new, Enemy)
end

local repulsionStrength = 0.1
local TileVoid = Void

function Enemy:update( dt, player, world )
    local pos = self.pos
    
    if world:getTileAt(pos.x, pos.y) == Void then
        print('Enemy felt')
        self.dead = true
        return
    end

    local targetDir = (player.pos - pos):normalized()
    local targetRot = (player.pos - pos):angle() + math.pi * 0.5

    -- enemies repulse each other
    local repulsion = Vector.new()
    for i, e in ipairs( Enemy.all ) do
        if e ~= self and not e.dead then
            local d = (pos - e.pos)
            local len = d:norm()
            repulsion = repulsion + d * (1/len * math.max(0, (repulsionStrength * 2 * size / len - repulsionStrength)) )
        end
    end

    -- targetDir = (targetDir + repulsion):normalized()

    self:smoothMove( world, dt, (targetDir + repulsion) * self.maxSpeed, targetRot )
end

function Enemy.updateAll(...)
    living = {}
    for i, e in ipairs(Enemy.all) do
        e:update(...)
        if not e.dead then
            table.insert(living, e)
        end
    end
    Enemy.all = living
end

return Enemy
