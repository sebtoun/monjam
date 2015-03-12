Level = {}
Level.__index = Level

local floorColor = { 200, 200, 200 }

-- size of tiles in px
local tileWidth, tileHeight = 128, 128

-- max size of world in tiles
local worldSize = 128

-- constants
TileFloor = 0
TileWall = 1 

function Level.new()
    local new = {
        sprites = {
            [TileFloor] = love.graphics.newImage( "assets/floor.jpg" ),
            [TileWall] = love.graphics.newImage( "assets/wall.jpg" )
        },
        tiles = {}
    }
    new.sprites[TileFloor]:setFilter("linear", "linear")

    return setmetatable(new, Level)
end

function Level:update(dt)

end

function Level:getTile(i, j)
    if math.sqrt(i * i + j * j) >= 32 then return TileWall end
    return self.tiles[j * worldSize + i] or TileFloor
end

function Level:getTileAt(x, y)
    return self:getTile(x / tileWidth, y / tileHeight)
end

function Level:draw( cam )
    -- draw tiles
    local xmin, ymin = cam:worldCoords(0, 0)
    local xmax, ymax = cam:worldCoords(love.graphics.getWidth(), love.graphics.getHeight())
    local w, h = tileWidth, tileHeight
    local sprites = self.sprites
    love.graphics.setColor(floorColor)
    for i = math.floor(xmin / w), math.floor(xmax / w) do
        for j = math.floor(ymin / h), math.floor(ymax / h) do
            local tile = sprites[self:getTile(i, j)]
            love.graphics.draw(tile, i * w, j * h, 0, w / tile:getWidth(), h / tile:getHeight())
        end
    end
end

return Level
