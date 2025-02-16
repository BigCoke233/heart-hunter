local background = {}

-- utilities

local function getRoomSize(room)
    local width = room.width * love.graphics.getWidth()
    local height = room.height * love.graphics.getHeight()
    return width, height
end

local function getRoomGap(room)
    local width, height = getRoomSize(room)
    local x = (love.graphics.getWidth() - width) / 2
    local y = (love.graphics.getHeight() - height) / 2
    return x, y
end

-- draw functions

function background.room()
    local room = G.currentRoom
    local width, height = getRoomSize(room)
    local x, y = getRoomGap(room)
    love.graphics.rectangle("line", x, y, width, height)
end

function background.doors()
    local room = G.currentRoom
    local roomX, roomY = getRoomGap(room)
    local roomW, roomH = getRoomSize(room)
    for d, door in ipairs(room.doors) do
        if (door ~= false) then
            local size = config.graphics.doorSize
            local thickness = config.graphics.doorThickness
            if d==DoorDirection.LEFT then
                local x = roomX - thickness / 2
                local y = (love.graphics.getHeight() - size) / 2
                love.graphics.rectangle("fill", x, y, thickness, size)
            elseif d==DoorDirection.RIGHT then
                local x = roomX - thickness / 2 + roomW
                local y = (love.graphics.getHeight() - size) / 2
                love.graphics.rectangle("fill", x, y, thickness, size)
            elseif d==DoorDirection.TOP then
                local x = (love.graphics.getWidth() - size) / 2
                local y = roomY - thickness / 2
                love.graphics.rectangle("fill", x, y, size, thickness)
            elseif d==DoorDirection.BOTTOM then
                local x = (love.graphics.getWidth() - size) / 2
                local y = roomY - thickness / 2 + roomH
                love.graphics.rectangle("fill", x, y, size, thickness)
            end
        end
    end
end

return background
