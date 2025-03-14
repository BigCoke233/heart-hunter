local Room = require "objects.room"

local mapGenerator = {}

function mapGenerator.generate(roomCount, initial)
    local firstRoom = Room:new(initial and "initialRoom" or nil)
    local map = { firstRoom }
    local available = utils.copy(map)

    for i = 2, (roomCount or config.initialMapSize) do
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
    local newMap = mapGenerator.generate(roomCount or config.extendedMapSize, true)
    local room = from or G.currentRoom

    -- try extending from the last room
    local entranceDoor, exitDoor = room:connect(newMap[1])
    if not entranceDoor or not exitDoor then
        -- if not doorless direction available in this room
        -- try extend from a random Room
        repeat
            room = utils.any(G.allRooms)
            if room ~= from and not room:isDoorFull() then
                print("extended from a random room")
                entranceDoor, exitDoor = room:connect(newMap[1])
                break
            end
        until false
    end
    if exitDoor then
        newMap[1]:removeDoor(exitDoor.location)
    end

    for _, newRoom in ipairs(newMap) do
        table.insert(G.allRooms, newRoom)
    end

    G.mapExpanded = true
end

return mapGenerator
