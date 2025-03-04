local roomData = require "data.roomData"

local roomNames = {}
for name, data in pairs(roomData) do
    if not data.manualPlacementOnly then
        table.insert(roomNames, name)
    end
end

return roomNames
