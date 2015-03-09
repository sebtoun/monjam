Player = require "Player"
require "aphrodisiacs/utils/vector"

Camera = require "camera"
Cursor = require "cursor"

local rnd = love.math.random
local maxColorRnd = 180
local player, cam, floorImg, floorColor, cursor, camDistance
local intent = { left = {}, right = {} }

function love.load( arg )
    player = Player.new()
    cam = Camera( 0, 0 )
    floorImg = love.graphics.newImage( "assets/grid.jpg" )
    -- floorColor = { rnd(0, maxColorRnd), rnd(0, maxColorRnd), rnd(0, maxColorRnd) }
    floorColor = { 200, 200, 200 }

    cursor = Cursor.new( player, cam )

    -- setup mouse mode
    love.mouse.setVisible( false )
    love.mouse.setGrabbed( true )
    love.mouse.setRelativeMode( true )

    camDistance = math.floor( 0.1 * math.min( love.graphics.getWidth(), love.graphics.getHeight() ) )
end

function love.keypressed( key, isrepeat )
    if ( key == 'escape' ) then
        love.event.quit()
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

    if (intent.dir.x > 0 or intent.dir.y > 0) then
        intent.dir = intent.dir:normalized()
    end

    intent.left.down = love.mouse.isDown('l')
    intent.right.down = love.mouse.isDown('r')

    player:update( dt, intent )
    cursor:update( dt )

    local sight = cursor.localPos:normalized()
    local targetx, targety = (player.pos + sight * camDistance):unpack()
    local dx, dy = targetx - cam.x, targety - cam.y
    cam:move(dx * 5 * dt, dy * 5 * dt)

    -- print( "cam: " .. "(" .. tostring(cam.x) .. ", " .. tostring(cam.y) .. ")" .. " cursor: " .. tostring(cursor.localPos) )
    -- reset intent for next frame
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

function love.draw()
    local w,h = floorImg:getWidth(), floorImg:getHeight()
    local xmin, ymin = cam:worldCoords(0, 0)
    local xmax, ymax = cam:worldCoords(love.graphics.getWidth(), love.graphics.getHeight())
    
    cam:attach()
    
    love.graphics.setColor(floorColor)
    for i = math.floor(xmin / w), math.floor(xmax / w) do
        for j = math.floor(ymin / h), math.floor(ymax / h) do
            love.graphics.draw(floorImg, i * w, j * h)
        end
    end
    player:draw()
    cursor:draw()

    cam:detach()

    love.graphics.setColor(220, 220, 220 )
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
end
