local Equipment = {}
Equipment.__index = Equipment

require("aphrodisiacs/collisions/hitbox")
require("aphrodisiacs/utils/vector")
mobs = require('enemy')

function Equipment.new(assignment, player, world)
    local new = {
        assignment = assignment,
        player = player,
        world = world
    }
    return setmetatable(new, Equipment)
end

function Equipment:update(dt, inputs)
    if inputs[self.assignment].pressed then
        self:activate(inputs)
    end
end

function Equipment:draw() end

function Equipment:activate(inputs) end

function Equipment.Sword(...)
    local sword = Equipment.new(...)
    
    -- strike at the side of player sprite
    local ext = sword.player.hitbox:extent() * 0.8
    sword.hitboxSize = ext
    sword.localPos = ((sword.assignment == 'left' and Vector.left or Vector.right) * (ext:norm() * 0.6)):rotate(-60 * math.pi / 180)
     
    local function relativePos( ref, localPos)
        local pos = ref.pos
        local rot = ref.rot
        
        return pos + localPos:rotate(rot)
    end

    function sword:activate(inputs)
        local pos = relativePos( self.player, self.localPos )

        self.hitbox = Hitbox.new(pos - self.hitboxSize * 0.5, pos + self.hitboxSize * 0.5)
        self.hitbox.ttl = 0.2
    end

    function sword:update(dt, inputs)
        local hit = self.hitbox
        if hit then
            local ttl = hit.ttl
            ttl = ttl - dt
            if ttl > 0 then
                hit.ttl = ttl
                hit:place( relativePos( self.player, self.localPos ) )
                -- deal damages on collisions
                for i, m in pairs(mobs.all) do
                    if hit:collide(m.hitbox) then
                        m.dead = true
                    end
                end
            else
                self.hitbox = nil
            end
        end
        Equipment.update(self, dt, inputs)
    end

    function sword:draw()
        if self.hitbox then
            self.hitbox:draw()
        end
    end
    
    return sword
end

return Equipment
