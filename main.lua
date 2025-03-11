require "config"
require "utils.utils"

require "render.sprite"
require "render.speaker"

local map = require "logic.map"
local controller = require "logic.controller"
local translator = require "i18n.translator"
local player = require "logic.player"


function love.load()
    local myFont = love.graphics.newFont("resources/fonts/MZPXflat.ttf", 17)
    love.graphics.setFont(myFont)

    sprite.load()

    local Renderer = require "render.renderer"
    RenderManager = Renderer.init()

    initGame()

    speaker.speak(translator.T("welcome"), 2, true)
end

function love.draw()
    RenderManager:draw()
end

function love.update(dt)
    -- physics world move forward
    G.world:update(dt)

    -- game logic updates
    local updates = { player, map, controller, speaker }
    for _, entity in ipairs(updates) do
        entity.update(dt)
    end

    -- update objects in current room
    G.currentRoom:update(dt)

    -- check if game has ended
    if not G.player:isAlive() then
        initGame()
    end

    -- time update
    G.time = G.time + dt
end

function love.keypressed(key)
    controller.keypressed(key)
end
