local Room = require "objects.room"

local mapGenerator = {}

function mapGenerator.generate(roomCount, initial)
    local firstRoom = Room:new(initial and "initialRoom" or nil)
    local map = { firstRoom }
    local available = utils.copy(map)

    for i = 2, (roomCount or config.map.initialRoomCount) do
        -- connect the room with a new room
        local newRoom = Room:new()
        local prevRoom = utils.any(available)
        prevRoom:connect(newRoom)

        if prevRoom:isDoorFull() then
            table.remove(available, utils.indexof(available, prevRoom))
        end

        table.insert(map, newRoom)
        table.insert(available, newRoom)
    end

    return map
end

function mapGenerator.continue(roomCount, from)
    -- continue game by extending the map
    local newMap = mapGenerator.generate(roomCount or config.map.extendedRoomCount, true)
    local room = from or G.currentRoom

    -- try extending from the last room
    local entranceDoor, exitDoor = room:connect(newMap[1])
    G.BodyLifeCycleManager:create(entranceDoor, { entranceDoor.w, entranceDoor.h }, "static")
    if exitDoor then
        newMap[1]:removeDoor(exitDoor.location)
    end

    for _, newRoom in ipairs(newMap) do
        table.insert(G.allRooms, newRoom)
    end

    G.mapExpanded = true
end

return mapGenerator
