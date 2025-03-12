require "data.directions"
local Room = require "objects.room"
local roomNames = require "data.roomNames"
local roomType = require "data.roomType"
local translator = require "i18n.translator"

local map = {}

-- control functions

function map.switchRoom(destination)
    -- unload current room
    G.currentRoom:removeAllBodies()

    -- load new room
    destination:init()
    G.currentRoom = destination

    if speaker.clearOnSwitchingRoom then
        speaker.clear()
    end
end

function map.generate(roomCount, initial)
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

function map.continue(roomCount, from)
    -- continue game by extending the map
    local newMap = map.generate(roomCount or config.extendedMapSize, true)
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
    speaker.speak(translator.T("newDoor"))
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
    if #G.currentRoom.objects.enemies==0 and not room.isCleared then
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
        speaker.speak(translator.T("newRealm"))
        G.mapExpanded = false
    end
end

return map
