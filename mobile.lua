local Mob = {}
Mob.__index = Mob

local Object = require "object"
setmetatable(Mob, Object)

require("aphrodisiacs/utils/vector")
require("aphrodisiacs/utils/mathExtension")

local rotSmooth = 0.1
local trSmooth = 0.12

function Mobile.new( x, y, skin, w, h )
    local new = Object.new(x, y, skin, w, h)

    new.vel = Vector.new()
    new.acc = Vector.new()
    new.angularVel = 0

    return setmetatable(new, Mob)
end

function Mobile:smoothMove( dt, targetVel, targetRot )
    -- smooth velocity
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
    self.rot, self.angularVel = math.smoothDampAngle(self.rot, targetRot, self.angularVel, rotSmooth, math.huge, dt)
end

return Mob
