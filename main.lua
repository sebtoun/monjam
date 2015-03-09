Player = require "Player"
require "aphrodisiacs/utils/vector"

Camera = require "camera"
Cursor = require "cursor"

local rnd = love.math.random
local maxColorRnd = 180
local player, cam, floorImg, floorColor, cursor, camDistance

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
    cursor:move(dx, dy)
end

function love.update( dt )
    inputs = {
        dir = Vector.new(),
        target = cursor:getPos():clone()
    }

    if love.keyboard.isDown('q') then
        inputs.dir = inputs.dir + Vector.left
    end

    if love.keyboard.isDown('d') then
        inputs.dir = inputs.dir + Vector.right
    end

    if love.keyboard.isDown('z') then
        inputs.dir = inputs.dir + Vector.up
    end

    if love.keyboard.isDown('s') then
        inputs.dir = inputs.dir + Vector.down
    end

    if (inputs.dir.x > 0 or inputs.dir.y > 0) then
        inputs.dir = inputs.dir:normalized()
    end

    player:update( dt, inputs )
    cursor:update( dt )

    local sight = cursor.localPos:normalized()
    local targetx, targety = (player.pos + sight * camDistance):unpack()
    local dx, dy = targetx - cam.x, targety - cam.y
    cam:move(dx * 5 * dt, dy * 5 * dt)

    -- print( "cam: " .. "(" .. tostring(cam.x) .. ", " .. tostring(cam.y) .. ")" .. " cursor: " .. tostring(cursor.localPos) )
    
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
