local Room = require "objects.room"

require "data.directions"
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

    if speaker.clearOnSwitchingRoom then
        speaker.clear()
    end
end

function map.generate(roomCount, initial)
    local firstRoom = Room:new(initial and "initialRoom" or nil)
    local rooms = { firstRoom }

    for i = 2, roomCount do
        local newRoom = Room:new()
        if not utils.any(rooms):connect(newRoom) then
            print("something wrong with connection")
        end
        table.insert(rooms, newRoom)
    end

    return rooms
end

function map.continue(roomCount, from)
    -- continue game by extending the map
    local newMap = map.generate(roomCount or config.initialMapSize, true)
    local room = from or G.currentRoom

    -- try extending from the last room
    if not room:connect(newMap[1]) then
        -- if not doorless direction available in this room
        -- try extend from a random Room
        repeat
            room = utils.any(G.allRooms)
            if room ~= from and not room:isDoorFull() then
                room:connect(newMap[1])
                break
            end
        until false
    end

    for _, newRoom in ipairs(newMap) do
        table.insert(G.allRooms, newRoom)
    end

    G.mapExpanded = true
    speaker.speak("A new door has opened.")
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
        print "room cleared"

        local unclearedRooms = {}
        for _, room in ipairs(G.allRooms) do
            if not room.isCleared then
                table.insert(unclearedRooms, room)
            end
        end

        print("uncleared rooms: ", #unclearedRooms)
    end

    -- extend map if all rooms are cleared
    if map.allCleared() then
        print "all cleared and try to continue"
        map.continue()
    end

    -- notify user if one's entered a new map
    if G.currentRoom.type == roomType.INITIAL and
        G.mapExpanded then
        speaker.speak("You're in a new realm now. Try heading back.")
        G.mapExpanded = false
    end
end
