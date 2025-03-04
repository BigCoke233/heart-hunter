require "config"

require "objects.body"
require "objects.room"
require "objects.door"
require "objects.shot"
require "objects.loot"
require "objects.player"
require "objects.enemy"
require "objects.direction"
require "objects.obstacle"

require "render.sprite"

require "logic.bullets"
require "logic.player"
require "logic.enemies"
require "logic.loot"
require "logic.map"

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
    renderer:add("background", nil, drawBackground.obstacles)
    renderer:add("objects", nil, drawObject.loot)
    renderer:add("objects", nil, drawObject.player)
    renderer:add("objects", nil, drawObject.enemies)
    renderer:add("objects", nil, drawObject.bullets)
    renderer:add("ui", nil, drawUI.ammoBar)
    renderer:add("ui", nil, drawUI.roomClearedCounter)

    math.randomseed(os.time())

    initGame()
end

function love.draw()
    renderer:draw()
end

local controller = require "logic.controller"

function love.update(dt)
    local updates = { player, enemies, bullets, loot, map, controller }
    for _, entity in ipairs(updates) do
        entity.update(dt)
    end

    if not G.player:isAlive() then
        initGame()
    end

    G.time = G.time + dt
end

function love.keypressed(key)
    controller.keypressed(key)
end
