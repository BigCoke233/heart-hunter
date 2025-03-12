local background = {}
local graphics = require "utils.graphics"

function background.room()
    graphics.drawRect(G.currentRoom, "line", true)
end

function background.doors()
    for i, door in pairs(G.currentRoom.doors) do
        if door ~= nil then
            love.graphics.setColor(door.color or {1,1,1})
            graphics.drawRect(door)
            graphics.reset()
        end
    end
end

return background
