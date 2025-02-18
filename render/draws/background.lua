local background = {}

function background.room()
    local room = G.currentRoom
    local width, height = room:getWidth(), room:getHeight()
    local x, y = room:getX(), room:getY()
    love.graphics.rectangle("line", x, y, width, height)
end

function background.doors()
    local room = G.currentRoom
    local roomX, roomY = room:getX(), room:getY()
    local roomW, roomH = room:getWidth(), room:getHeight()

    for d, door in ipairs(room.doors) do
        if door ~= false then
            local size = config.graphics.doorSize
            local thickness = config.graphics.doorThickness
            local x, y

            if d == Direction.LEFT or d == Direction.RIGHT then
                x = (d == Direction.LEFT) and (roomX - thickness / 2) or (roomX - thickness / 2 + roomW)
                y = (love.graphics.getHeight() - size) / 2
                love.graphics.rectangle("fill", x, y, thickness, size)
            elseif d == Direction.TOP or d == Direction.BOTTOM then
                x = (love.graphics.getWidth() - size) / 2
                y = (d == Direction.TOP) and (roomY - thickness / 2) or (roomY - thickness / 2 + roomH)
                love.graphics.rectangle("fill", x, y, size, thickness)
            end
        end
    end
end

return background
