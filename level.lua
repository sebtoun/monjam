Level = {}
Level.__index = Level

local floorColor = { 200, 200, 200 }

-- size of tiles in px
local tileWidth, tileHeight = 128, 128

-- max size of world in tiles
local worldSize = 64
local towerRadius = 30

-- constants
TileFloor = 0
TileWall = 1
TileVoid = -1

local floor = math.floor

local noise = love.math.noise
local function genFractalNoise2(x, y, iter, amp, freq)
    val = noise(x, y)*2-1
    freq = freq or 2
    iter = iter or 1
    amp = amp or 0.5
    local n = 1
    while n < iter do
        val = val + (noise(x*freq, y*freq)*2-1)*amp
        freq = freq * freq
        amp = amp * amp
        n = n + 1
    end
    return math.max(math.min(val, 1.0), -1.0)
end

function Level.new()
    local new = {
        sprites = {
            [ TileFloor ] = love.graphics.newImage( "assets/floor.jpg" ),
            [ TileWall ] = love.graphics.newImage( "assets/wall.jpg" ),
            [ TileVoid ] = love.graphics.newImage( "assets/void.jpg" )
        },
        tiles = {}
    }
    
    new.sprites[ TileFloor ]:setFilter( "linear", "linear" )
    return setmetatable( new, Level )
end

function Level:generateTiles( thresh, iter, freq )
    for i = -worldSize, worldSize do
    for j = -worldSize, worldSize do
        self.tiles[ j * worldSize + i ] = genFractalNoise2(i * tileWidth, j * tileHeight, iter, 0.5, freq) > thresh and TileWall or TileFloor 
    end
    end
end

function Level:update( dt )

end

function Level:getTile( i, j )
    local distance = i * i + j * j 
    if distance >= (towerRadius + 2) * (towerRadius + 2) then 
        return TileVoid 
    end
    if distance >= towerRadius * towerRadius then 
        return TileWall 
    end
    return self.tiles[ j * worldSize + i ] or TileFloor
end

function Level:getTileAt( x, y )
    return self:getTile( self:getTileIndicesAt( x, y ) )
end

function Level:getTileIndicesAt( x, y )
    return floor(x / tileWidth), floor(y / tileHeight)
end

local function collide( min, max, i, j )
    collision = {
        depth = nil,
        normal = nil
    }

    -- the side on which the collision occurs is the side the least into the other object
    local function testOverlap( overlap, normal )
        if overlap < 0 then return false end

        if ( not collision.depth ) or ( overlap < collision.depth ) then
            collision.depth = overlap
            collision.normal = normal
        end

        return true
    end

    local tileMin = { x = i * tileWidth, y = j * tileHeight }
    local tileMax = { x = tileMin.x + tileWidth, y = tileMin.y + tileHeight }
    if not testOverlap( tileMax.x - min.x, Vector.right ) then return nil end
    if not testOverlap( max.x - tileMin.x, Vector.left ) then return nil end
    if not testOverlap( tileMax.y - min.y, Vector.down ) then return nil end
    if not testOverlap( max.y - tileMin.y, Vector.up ) then return nil end

    return collision
end

function Level:checkCollisionsWithWalls( min, max )
    local w, h = tileWidth, tileHeight
    local wall = TileWall
    local disp = Vector.new()
    for i = floor( min.x / w ), floor( max.x / w ) do
    for j = floor( min.y / h ), floor( max.y / h ) do
        if self:getTile( i, j ) == wall then
            local col = collide( min, max, i, j )
            if col then
                disp = disp + col.normal * col.depth 
                min = min + col.normal * col.depth 
                max = max + col.normal * col.depth 
            end
        end
    end
    end
    if disp:sqrNorm() > 0 then
        return disp
    end
end

function Level:draw( cam )
    -- draw tiles
    local xmin, ymin = cam:worldCoords( 0, 0 )
    local xmax, ymax = cam:worldCoords( love.graphics.getWidth(), love.graphics.getHeight() )
    local w, h = tileWidth, tileHeight
    local sprites = self.sprites
    love.graphics.setColor( floorColor )
    for i = floor( xmin / w ), floor( xmax / w ) do
    for j = floor( ymin / h ), floor( ymax / h ) do
        local tile = sprites[ self:getTile( i, j ) ]
        love.graphics.draw( tile, i * w, j * h, 0, w / tile:getWidth(), h / tile:getHeight() )
    end
    end
end

return Level
