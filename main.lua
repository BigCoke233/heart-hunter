config = require "config"
draws = require "render/draws"

bullets = require "logic.bullets"
player = require "logic.player"
ui = require "render.ui"
enemies = require "logic.enemies"
loot = require "logic.loot"
sprite = require "render.sprite"


Room = require "objects.room"
Renderer = require "render.renderer"

function love.load()
    love.window.setIcon(love.image.newImageData("resources/sprites/redheart.png"))
    love.window.setTitle("Heart Hunter")

    renderer = Renderer:new()
    renderer:add("objects", nil, draws.player)
    renderer:add("objects", nil, draws.bullets)
    renderer:add("objects", nil, draws.enemies)
    renderer:add("objects", nil, draws.loot)
    renderer:add("ui", nil, ui.drawAmmoBar)

    sprite.load()
    initGame()
    enemies.summon()
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
