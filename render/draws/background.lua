local background = {}

function background.room()
    local room = G.currentRoom
    local width, height = room:getWidth(), room:getHeight()
    local x, y = room:getX(), room:getY()
    love.graphics.rectangle("line", x, y, width, height)
end

function background.doors()
    for i, door in ipairs(G.currentRoom.doors) do
        if door ~= nil then
            love.graphics.rectangle("fill", door.x, door.y, door.width, door.height)
        end
    end
end

return background
