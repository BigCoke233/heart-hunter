local background = {}

function background.room()
    local room = G.currentRoom
    local width, height = room:getWidth(), room:getHeight()
    local x, y = room:getX(), room:getY()
    love.graphics.rectangle("line", x, y, width, height)
end

function background.doors()
    for i, door in pairs(G.currentRoom.doors) do
        if door ~= nil then
            local x, y = door.x - door.w / 2, door.y - door.h / 2
            love.graphics.setColor(door.color or {1,1,1})
            love.graphics.rectangle("fill", x, y, door.w, door.h)
            utils.resetGraphics()
        end
    end
end

return background
