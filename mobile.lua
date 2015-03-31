local Mobile = {
    all = {}
}
Mobile.__index = Mobile

local Object = require "object"
setmetatable(Mobile, Object)

require("aphrodisiacs/utils/vector")
require("aphrodisiacs/utils/mathExtension")

function Mobile.new( x, y, skin, w, h )
    local new = Object.new(x, y, skin, w, h)

    new.rotSmooth = 0.1
    new.trSmooth = 0.12

    new.vel = Vector.new()
    new.acc = Vector.new()
    new.angularVel = 0

    table.insert(Mobile.all, new)

    return setmetatable(new, Mobile)
end

function Mobile:smoothMove( dt, targetVel, targetRot )
    -- smooth velocity
    self.vel.x, self.acc.x = math.smoothDamp(self.vel.x, targetVel.x, self.acc.x, self.trSmooth, math.huge, dt)
    self.vel.y, self.acc.y = math.smoothDamp(self.vel.y, targetVel.y, self.acc.y, self.trSmooth, math.huge, dt)

    -- move position
    self:move( self.vel * dt )

    -- smooth rotation
    self.rot, self.angularVel = math.smoothDampAngle(self.rot, targetRot, self.angularVel, self.rotSmooth, math.huge, dt)
end

return Mobile
