require "config"
require "utils.utils"
require "render.sprite"
require "render.speaker"
local audio = require "utils.audio"
local map = require "logic.map"
local controller = require "logic.controller"
local translator = require "i18n.translator"

function love.load()
    G = {}
    -- load font
    local myFont = love.graphics.newFont("resources/fonts/MZPXflat.ttf", 17)
    love.graphics.setFont(myFont)

    -- load sprite and initialize renderer
    sprite.load()
    local Renderer = require "render.renderer"
    RenderManager = Renderer.init()

    -- load audio
    audio.load()

    -- initialize game state
    initGame()

    -- set world callbacks
    G.world:setCallbacks(onContact)

    speaker.speak(translator.T("welcome"), 2, true)
end

function love.draw()
    RenderManager:draw()
end

function love.update(dt)
    -- game state updates
    local gameStates = { G.world, G.currentRoom, G.player, G.BodyLifeCycleManager }
    for _, state in ipairs(gameStates) do
        state:update(dt)
    end

    -- game logic updates
    local updates = { map, controller, speaker }
    for _, entity in ipairs(updates) do
        entity.update(dt)
    end

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

function onContact(a, b, contact)
    local objectA = utils.whoseBody(a:getBody())
    local objectB = utils.whoseBody(b:getBody())
    if objectA and objectB then
        if objectA.onContact then
            objectA:onContact(objectB, contact)
        end
        if objectB.onContact then
            objectB:onContact(objectA, contact)
        end
    end
end
