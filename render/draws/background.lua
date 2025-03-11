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
            love.graphics.setColor(door.color or {1,1,1})
            door.body:draw(door.x, door.y)
            utils.resetGraphics()
        end
    end
end

return background
