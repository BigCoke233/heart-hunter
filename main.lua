config = require "config"

bullets = require "logic.bullets"
player = require "logic.player"
enemies = require "logic.enemies"
loot = require "logic.loot"
sprite = require "render.sprite"

Room = require "objects.room"
Renderer = require "render.renderer"

function love.load()
    love.window.setIcon(love.image.newImageData("resources/sprites/redheart.png"))
    love.window.setTitle("Heart Hunter")

    sprite.load()

    renderer = Renderer:new()
    local drawObject = require "render.draws.objects"
    local drawUI = require "render.draws.ui"
    renderer:add("objects", nil, drawObject.player)
    renderer:add("objects", nil, drawObject.bullets)
    renderer:add("objects", nil, drawObject.enemies)
    renderer:add("objects", nil, drawObject.loot)
    renderer:add("ui", nil, drawUI.ammoBar)

    initGame()
end

function love.update(dt)
    player.move(dt)
    bullets.update(dt)

    player.beingAttacked()
    enemies.beingShot()
    loot.beingPicked()

    if not player.isAlive() then
        print("Out of hearts. You died!")
        initGame()
    end

    G.time = G.time + dt
end

function love.draw()
    renderer:draw()
end

function love.mousereleased(x, y, button, istouch)
    if button == 1 then
        bullets.shoot(x, y, G.player.x, G.player.y, shots)
    end
end
