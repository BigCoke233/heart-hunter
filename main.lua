require "config"
require "data.enemyData"
require "data.heartTypes"

require "logic.bullets"
require "logic.player"
require "logic.enemies"
require "logic.loot"
require "logic.map"

require "render.sprite"

require "objects.body"
require "objects.room"
require "objects.door"
require "objects.enemy"
require "objects.direction"
require "objects.obstacle"

require "utils.renderer"
require "utils.utils"

function love.load()
    love.window.setIcon(love.image.newImageData("resources/sprites/redheart.png"))
    love.window.setTitle("Heart Hunter")

    sprite.load()

    renderer = Renderer:new()
    local drawObject = require "render.draws.objects"
    local drawUI = require "render.draws.ui"
    local drawBackground = require "render.draws.background"
    renderer:add("background", nil, drawBackground.room)
    renderer:add("background", nil, drawBackground.doors)
    renderer:add("objects", nil, drawObject.loot)
    renderer:add("objects", nil, drawObject.player)
    renderer:add("objects", nil, drawObject.enemies)
    renderer:add("objects", nil, drawObject.bullets)
    renderer:add("ui", nil, drawUI.ammoBar)

    math.randomseed(os.time())

    initGame()
end

function love.update(dt)
    local updates = { player, enemies, bullets, loot, map }
    for _, entity in ipairs(updates) do
        entity.update(dt)
    end

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
