require "aphrodisiacs/utils/vector"

Camera = require "camera"
Cursor = require "cursor"

local player, cam, world, cursor, camDistance, intent
local abs = math.abs


local entities = {}

DEBUG = true

tileWidth, tileHeight = 128, 128 -- default tile size

function resetIntent()
    intent = {
        left = {
            pressed = false,
            released = false
        },
        right = {
            pressed = false,
            released = false
        }
    }
end

local thresh, octaves, freq = 0.5, 3, 0.01

function love.load( arg )
    tileWidth, tileHeight = 128, 128

    Level = require "level"
    Player = require "Player"

    cam = Camera( 0, 0 )

    player = Player.new()
    cursor = Cursor.new( player, cam )

    world = Level.new()
    world:generateTiles( thresh, octaves, freq )

    -- setup mouse mode
    love.mouse.setVisible( false )
    love.mouse.setGrabbed( true )
    love.mouse.setRelativeMode( true )

    camDistance = math.floor( 0.1 * math.min( love.graphics.getWidth(), love.graphics.getHeight() ) )
    resetIntent()
end

function love.keypressed( key, isrepeat )
    if ( key == 'escape' ) then
        love.event.quit()
    end
    if ( key == 'j' ) then
        freq = freq / 2
        world:generateTiles( thresh, octaves, freq )
    end
    if ( key == 'k' ) then
        freq = freq * 2
        world:generateTiles( thresh, octaves, freq )
    end
    if ( key == 'h' ) then
        octaves = math.max(octaves - 1, 1)
        world:generateTiles( thresh, octaves, freq )
    end
    if ( key == 'l' ) then
        octaves = octaves + 1
        world:generateTiles( thresh, octaves, freq )
    end
end

function love.mousemoved( x, y, dx, dy )
    cursor:move( dx, dy )
end

function love.mousepressed( x, y, button )
    if button == 'l' then
        intent.left.pressed = true
    elseif button == 'r' then
        intent.right.pressed = true
    end
end

function love.mousereleased( x, y, button )
    if button == 'l' then
        intent.left.released = true
    elseif button == 'r' then
        intent.right.released = true
    end
end

function love.update( dt )
    -- handle inputs
    intent.dir = Vector.new()
    intent.target = cursor:getPos():clone()
    
    if love.keyboard.isDown('q') or love.keyboard.isDown('left') then
        intent.dir = intent.dir + Vector.left
    end

    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        intent.dir = intent.dir + Vector.right
    end

    if love.keyboard.isDown('z') or love.keyboard.isDown('up') then
        intent.dir = intent.dir + Vector.up
    end

    if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        intent.dir = intent.dir + Vector.down
    end

    if abs(intent.dir.x) > 0 or abs(intent.dir.y) > 0 then
        intent.dir = intent.dir:normalized()
    end

    intent.left.down = love.mouse.isDown('l')
    intent.right.down = love.mouse.isDown('r')

    -- world
    world:update( dt )

    -- entities
    for i, e in pairs(entities) do
        e.update( dt, world )
    end

    -- components
    player:update( dt, intent, world )
    cursor:update( dt )

    -- camera
    local sight = cursor.localPos:normalized()
    local targetx, targety = (player.pos + sight * camDistance):unpack()
    local dx, dy = targetx - cam.x, targety - cam.y
    cam:move(dx * 5 * dt, dy * 5 * dt)

    -- reset inputs for next frame
    resetIntent()
end

function love.draw()
    cam:attach()

    -- components
    world:draw(cam)
    
    -- entities
    for i, e in pairs(entities) do
        e.draw()
    end

    player:draw()
    cursor:draw()

    cam:detach()

    -- draw HUD
    love.graphics.setColor(220, 220, 220 )
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print("world gen: (jk) freq="..tostring(freq), 10, 30)
    love.graphics.print("world gen: (hl) iter="..tostring(octaves), 10, 50)
end
