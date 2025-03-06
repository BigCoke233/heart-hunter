require "config"

require "logic.bullets"
require "logic.player"
require "logic.enemies"
require "logic.loot"
require "logic.map"

require "utils.utils"

require "render.sprite"
local Renderer = require "render.renderer"

-- initializers

local function initRenderer()
    RenderManager = Renderer:new()
    local drawObject = require "render.draws.objects"
    local drawUI = require "render.draws.ui"
    local drawBackground = require "render.draws.background"

    RenderManager:addFunctions("background", nil, drawBackground)
    RenderManager:addFunctions("objects", nil, drawObject)
    RenderManager:addFunctions("ui", nil, drawUI)
end

-- entry functions

function love.load()
    love.window.setIcon(love.image.newImageData("resources/sprites/redheart.png"))
    love.window.setTitle("Heart Hunter")

    sprite.load()
    initRenderer()

    math.randomseed(os.time())
    initGame()
end

function love.draw()
    RenderManager:draw()
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
