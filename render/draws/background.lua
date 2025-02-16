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
        if (door ~= false) then
            local size = config.graphics.doorSize
            local thickness = config.graphics.doorThickness
            if d==Direction.LEFT then
                local x = roomX - thickness / 2
                local y = (love.graphics.getHeight() - size) / 2
                love.graphics.rectangle("fill", x, y, thickness, size)
            elseif d==Direction.RIGHT then
                local x = roomX - thickness / 2 + roomW
                local y = (love.graphics.getHeight() - size) / 2
                love.graphics.rectangle("fill", x, y, thickness, size)
            elseif d==Direction.TOP then
                local x = (love.graphics.getWidth() - size) / 2
                local y = roomY - thickness / 2
                love.graphics.rectangle("fill", x, y, size, thickness)
            elseif d==Direction.BOTTOM then
                local x = (love.graphics.getWidth() - size) / 2
                local y = roomY - thickness / 2 + roomH
                love.graphics.rectangle("fill", x, y, size, thickness)
            end
        end
    end
end

return background
