Player = require("Player")
require("aphrodisiacs/utils/vector")

Camera = require "camera"

local rnd = love.math.random
local maxColorRnd = 180

function love.load(arg)
    player = Player.new()
    cam = Camera(0, 0)
    floorImg = love.graphics.newImage("assets/grid.jpg")
    -- floorColor = { rnd(0, maxColorRnd), rnd(0, maxColorRnd), rnd(0, maxColorRnd) }
    floorColor = { 200, 200, 200 }

    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)
    cursor = love.graphics.newImage("assets/cursor.png")
    cursorColor = { 207, 67, 67 }
end

function love.keypressed(key, isrepeat)
    if (key == 'escape') then
        love.event.quit()
    end
end

function love.update(dt)
    inputs = {
        dir = Vector.new(),
        target = Vector.new(cam:mousepos())
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

    player:update(dt, inputs)

    local targetx, targety = (player.pos.x * 2 + inputs.target.x) / 3, (player.pos.y * 2 + inputs.target.y) / 3
    local dx, dy = targetx - cam.x, targety - cam.y
    cam:move(dx * 5 * dt, dy * 5 * dt)
    -- cam:lookAt(math.round(targetx), math.round(targety))
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
    cam:detach()
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
    local mousex, mousey = love.mouse.getPosition()
    love.graphics.setColor(cursorColor)
    love.graphics.draw(cursor, mousex, mousey, 0, 1, 1, cursor:getWidth() * 0.5, cursor:getHeight() * 0.5)
end
