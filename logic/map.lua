local roomNames = require "data.roomNames"
local roomType = require "data.roomType"

map = {}

-- control functions

function map.switchRoom(to)
    local destination

    if type(to) == "table" then
        destination = to
    elseif type(to) == "number" then
        destination = G.currentRoom.doors[Direction[to]]
    end

    destination:init()
    G.currentRoom = destination
    G.enemies = G.currentRoom.enemies
end

function map.generate(roomCount, initial)
    local rooms = {}
    local availableRooms = {}

    local firstRoom
    if initial then
        firstRoom = Room:new("initialRoom")
    else
        firstRoom = Room:new(utils.any(roomNames))
    end
    table.insert(rooms, firstRoom)
    table.insert(availableRooms, firstRoom)

    for i = 2, roomCount do
        local newRoom = Room:new(utils.any(roomNames))

        -- select an available room and connect
        local prevRoom = utils.any(availableRooms)
        if not newRoom:connect(prevRoom) then
            print("room connection failed")
        end
        if prevRoom:isDoorFull() then
            table.remove(availableRooms, utils.indexof(availableRooms, prevRoom))
        end

        table.insert(rooms, newRoom)
        table.insert(availableRooms, newRoom)
    end

    return rooms
end

function map.continue(roomCount, from)
    -- continue game by extending the map
    local newMap = map.generate(roomCount or 5)
    if not from then from = G.currentRoom end

    -- try extend from the last room
    if not from.connect(newMap[1]) then
        -- if not doorless direction available in this room
        -- try extend from a random Room
        repeat
            local room = utils.any(G.allRooms)
            if room ~= from and not room:isDoorFull() then
                room:connect(newMap[1])
                break
            end
        until false
    end
end

-- boolean functions

function map.allCleared()
    local allCleared = true
    for _, room in ipairs(G.allRooms) do
        if not room.isCleared then
            allCleared = false
            break
        end
    end
    return allCleared
end

-- entry functions

function map.update()
    local room = G.currentRoom

    -- check if room is cleared
    if #G.enemies==0 and not room.isCleared then
        room.isCleared = true
        if room.type ~= roomType.INITIAL then
            G.roomCleared = G.roomCleared + 1
        end
    end

    -- extend map if all rooms are cleared
    if map.allCleared() then
        map.continue(5)
    end
end
