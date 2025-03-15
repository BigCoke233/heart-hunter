require "data.directions"
local mapGen = require "logic.MapGenerator"
local roomType = require "data.roomType"
local translator = require "i18n.translator"
local audio = require "utils.audio"
local MobSpawn = require "logic.MobSpawn"

local map = {}

-- control functions

function map.switchRoom(destination)
    -- unload current room
    G.currentRoom:unload()

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

    -- if room's cleared once or in a wave currently
    -- try to summon mob waves
    local waveGoingOn = room.currentWave and room.currentWave <= MobSpawn.waveNumber(room)
    if (#room.objects.enemies==0 or waveGoingOn) and not room.isCleared then
        -- do not clear room if beforeClear event is not finished
        if room.type == roomType.COMBAT
            and not MobSpawn.waves(G.currentRoom) then
            return
        end
        -- if after beforeClear event, there no enemy left_x
        -- then consider room cleared
        if #room.objects.enemies==0 and not room.currentWave then
            room.isCleared = true
            -- handle post-clear actions
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
