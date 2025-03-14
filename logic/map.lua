require "data.directions"
local mapGen = require "logic.MapGenerator"
local roomType = require "data.roomType"
local translator = require "i18n.translator"
local audio = require "utils.audio"

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

-- handle room clearance

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
        if G.currentRoom.events.beforeClear then
            G.currentRoom.events.beforeClear()
        end

        if #G.currentRoom.objects.enemies==0 then
            room.isCleared = true

            if room.type ~= roomType.INITIAL then
                G.roomCleared = G.roomCleared + 1
                audio.play("levelComplete")
            end
        end
    end

    -- extend map if all rooms are cleared
    if map.allCleared() then
        mapGen.continue()
        speaker.speak(translator.T("newDoor"))
    end

    -- notify user if one's entered a new map
    if G.currentRoom.type == roomType.INITIAL and
        G.mapExpanded then
        speaker.speak(translator.T("newRealm"))
        G.mapExpanded = false
    end
end

return map
