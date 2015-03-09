local Cursor = {}
Cursor.__index = Cursor

local defaultColor = { 210, 40, 40 }
local minDistance = 1
local scale = 3
Cursor.cursor = love.graphics.newImage("assets/cursor.png")

function Cursor.new( anchor, cam, color )
    color = color or defaultColor

    local new = {
        localPos = Vector.new(1, 0),
        color = color,
        anchor = anchor,
        cam = cam,
    }
    
    return setmetatable(new, Cursor)
end

function Cursor:move( dx, dy )
    local pos = self.localPos
    repeat
        pos:add_inplace(dx, dy)
    until pos:norm() > minDistance
end

function Cursor:draw()
    local cursor = Cursor.cursor
    local drawPos = self:getPos()
    love.graphics.setColor(self.color)
    love.graphics.draw(cursor, drawPos.x, drawPos.y, 0, 2, 2, cursor:getWidth() * 0.5, cursor:getHeight() * 0.5)
end

function Cursor:getPos()
    return self.anchor.pos + self.localPos
end

function Cursor:setPos( pos )
    self.localPos = pos - self.anchor.pos
end

function Cursor:update( dt )
    -- clamp on cam bounds
    pos = self:getPos()
    local xmin, ymin = self.cam:worldCoords(0, 0)
    local xmax, ymax = self.cam:worldCoords(love.graphics.getWidth(), love.graphics.getHeight())
    pos.x, pos.y = math.max(xmin, pos.x), math.max(ymin, pos.y) 
    pos.x, pos.y = math.min(xmax, pos.x), math.min(ymax, pos.y)
    self:setPos(pos)
end

return Cursor