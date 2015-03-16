local Object = {}
Object.__index = Object

require("aphrodisiacs/utils/vector")
require("aphrodisiacs/collisions/hitbox")

function Object.new( x, y, skin, w, h )
    x, y = x or 0, y or 0
    w, h = w or skin and skin:getWidth() or tileWidth, h or skin and skin:getHeight() or tileHeight
    skin = skin or hitbox
    local new = {
        pos = Vector.new( x, y ),
        size = Vector.new( w, h ),
        rot = 0,
        skin = skin,
        hitbox = Hitbox.new( Vector.new( x - w / 2, y - h / 2 ), Vector.new( x + w / 2, y + h / 2 ) )
    }
    return setmetatable(new, Object)
end

function Object:draw()
    love.graphics.push()
    love.graphics.translate( self.pos.x, self.pos.y )
    love.graphics.rotate( self.rot )

    self.skin:draw()
    
    love.graphics.pop()

    if DEBUG then
        self.hitbox:draw()
    end
end

function Object:move( delta )
    self.pos:add_inplace( delta.x, delta.y )
    self.hitbox:move( delta )
end

return Object
