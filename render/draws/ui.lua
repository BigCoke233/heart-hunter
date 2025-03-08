local ui = {}

function ui.ammoBar()
    local height = 30
    local y = love.graphics.getHeight() - height
    local x = 10
    local gap = 20

    local hearts = G.player.hearts
    for i, v in pairs(hearts) do
        local position = { x = x+gap*(i-1), y = y }
        local heartR = config.heartSize

        -- if a heart is charging
        -- draw circle behind it to indicate the progress
        local chargingStarted = G.player.chargingStarted
        local chargingTime = G.time - (chargingStarted or 0)
        if chargingStarted and i==#hearts then
            local arc = math.pi * 2 * (chargingTime or 0)
            love.graphics.setColor(1,0,0,0.6)
            love.graphics.arc("fill", position.x+heartR/2, position.y+heartR/2,
                config.heartSize, 0, arc)
            utils.resetGraphics()
        end

        -- draw heart
        sprite.drawSquare(v, position, heartR)
    end
end

function ui.roomClearedCounter()
    love.graphics.print("Room Cleared: " .. G.roomCleared, 0, 0)
end

function ui.roomName()
    local text = G.currentRoom.name
    local screenWidth = love.graphics.getWidth()
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(text)

    love.graphics.print(text, screenWidth - textWidth, 0)
end

function ui.speakerText()
    speaker.print()
end

return ui
