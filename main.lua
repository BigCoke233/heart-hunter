require "config"
require "utils.utils"
require "render.sprite"
require "render.speaker"
local audio = require "utils.audio"
local map = require "logic.map"
local controller = require "logic.controller"
local translator = require "i18n.translator"

local gameState = "playing"  -- 初始状态为playing

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

    speaker.speak(translator.T("welcome"), 2, true)
end

function love.draw()
    if gameState == "playing" then
        RenderManager:draw()
    elseif gameState == "gameOver" then
        -- show game over screen
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.printf(translator.T("gameOver"), 0, love.graphics.getHeight() / 2 - 20, love.graphics.getWidth(), "center")
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(translator.T("pressSpaceToRestart"), 0, love.graphics.getHeight() / 2 + 20, love.graphics.getWidth(), "center")
        -- play game over sound
        audio.play("gameover")
    end
end

function love.update(dt)
    if gameState == "playing" then
        -- game state updates
        local gameStates = { G.BodyLifeCycleManager, G.world, G.currentRoom, G.player }
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
            gameState = "gameOver"
            audio.stopAll()
        end

        -- time update
        G.time = G.time + dt
    end
end

function love.keypressed(key)
    -- press space to restart gane
    if gameState == "gameOver" and key == "space" then
        initGame()
        gameState = "playing"
    else
        controller.keypressed(key)
    end
end

function love.mousereleased(x, y, button)
    controller.mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
    controller.wheelmoved(x, y)
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
