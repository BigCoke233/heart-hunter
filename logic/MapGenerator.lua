local Room = require "objects.room"
local Loot = require "objects.loot"

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

    -- attempt to find an available room
    local connected = false
    local attempts = 0
    local maxAttempts = 10

    while not connected and attempts < maxAttempts do
        -- if doorfull
        if room:isDoorFull() then
            -- find an available room
            for _, existingRoom in ipairs(G.allRooms) do
                if not existingRoom:isDoorFull() then
                    room = existingRoom
                    break
                end
            end
        end

        -- try to connect
        local entranceDoor, exitDoor = room:connect(newMap[1])
        if entranceDoor then
            connected = true
            if entranceDoor then
                G.BodyLifeCycleManager:create(entranceDoor, { entranceDoor.w, entranceDoor.h }, "static")
            end
            if exitDoor then
                newMap[1]:removeDoor(exitDoor.location)
            end
        else
            -- if failed, generate a new map
            newMap = mapGenerator.generate(roomCount or config.map.extendedRoomCount, true)
        end

        attempts = attempts + 1
    end

    if not connected then
        print("Warning: Failed to connect new rooms after " .. maxAttempts .. " attempts")
        return false
    end

    for _, newRoom in ipairs(newMap) do
        table.insert(G.allRooms, newRoom)
    end

    G.mapExpanded = true
    return true
end

function mapGenerator.init(G)
    -- generate map
    G.allRooms = mapGenerator.generate(config.map.initialRoomCount, true)
    G.currentRoom = G.allRooms[1]

    -- add random initial loot
    local heartCount = math.random(
        config.map.initialHeartCount.min,
        config.map.initialHeartCount.max
    )
    for i=1, heartCount do
        table.insert(
            G.currentRoom.objects.loots,
            Loot:random(G.currentRoom:getLocation("random", 100))
        )
    end

    -- initialize room
    G.currentRoom:init()
end

return mapGenerator
