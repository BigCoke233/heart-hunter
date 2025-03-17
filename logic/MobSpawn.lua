local Enemy = require "objects.enemy"
local roomData = require "data.roomData"
local translator = require "i18n.translator"

local MobSpawn = {}

function MobSpawn.waveNumber(room)
    return #roomData[room.dataName].waves
end

function MobSpawn.waves(room)
    local data = roomData[room.dataName]
    if data.waves then
        -- initialize if no waves going on
        if not room.currentWave then
            room.currentWave = 1
        elseif room.currentWave <= #data.waves then
            local waveData = data.waves[room.currentWave]

            -- pre-wave actions
            if not room.waveStarted then
                speaker.speak(translator.T(waveData.message or "waveStart"))
                room.waveStarted = true
            end

            -- only when all enemies are spawned and killed
            -- move on to next wave
            local waveFinished = MobSpawn.doOneWave(waveData.mobs, room)
            if waveFinished then
                room.currentWave = room.currentWave + 1
                room.waveStarted = false -- 重置状态
            end
        else
            room.currentWave = nil
            return true -- 所有波次完成
        end
        return false
    end
    return true
end

function MobSpawn.doOneWave(mobs, room)
    if not room.currentWaveMobIndex then
        room.currentWaveMobIndex = 1
        room.doNotSummonTill = G.time
    elseif room.currentWaveMobIndex <= #mobs and G.time >= room.doNotSummonTill then
        local enemyName = mobs[room.currentWaveMobIndex]
        if enemyName then
            local enemy = Enemy:new(enemyName, "anyDoor")
            table.insert(room.objects.enemies, enemy)
            enemy:placeInRoom(room)
        end
        room.currentWaveMobIndex = room.currentWaveMobIndex + 1
        room.doNotSummonTill = G.time + config.wave.mobSummonDelay
    end

    -- 如果所有怪物都已经生成，返回 true，通知 waves 进入下一波
    if room.currentWaveMobIndex > #mobs
        and #room.objects.enemies == 0 then
        room.currentWaveMobIndex = nil
        return true
    end
    return false
end

return MobSpawn
