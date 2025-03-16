local audio = {}

local soundResources = {
    shootNormal = "shoot_normal.wav",
    shootFlash = "shoot_flash.wav",
    hit = "hit.wav",
    hitGlass = "hit_glass.wav",
    levelComplete = "level_complete.wav",
    warning = "warning.wav",
    getsHit = "gets_hit.wav",
    getsItem = "gets_item.wav",
    punch = "punch.wav",
    door = "door.wav"
}

local musicResources = {
    briskFight = "brisk_fight.wav",
    intenseFight = "intense_fight.wav",
    discoFight = "disco_fight.wav",
    beginning = "beginning.wav"
}

function audio.load()
    AudioData = {}
    for name, path in pairs(soundResources) do
        AudioData[name] = love.audio.newSource("resources/sound/" .. path, "static")
    end
    for name, path in pairs(musicResources) do
        AudioData[name] = love.audio.newSource("resources/music/" .. path, "stream")
        AudioData[name]:setLooping(true)
    end
end

function audio.play(name, loop, volume)
    local theAudio = AudioData[name]
    if not theAudio then return end

    if volume then
        theAudio:setVolume(volume)
    end

    if loop then
        if not theAudio:isLooping() then
            theAudio:setLooping(true)
            love.audio.play(theAudio)
        end
    else
        love.audio.play(theAudio)
    end
end

function audio.stop(name)
    local theAudio = AudioData[name]
    if not theAudio then return end

    if theAudio:isPlaying() then
        love.audio.stop(theAudio)
        theAudio:setLooping(false)
    end
end

function audio.music(name)
    if G.musicPlaying == name then
        return
    elseif G.musicPlaying then
        audio.stopMusic()
    end

    if AudioData[name] then
        love.audio.play(AudioData[name])
        G.musicPlaying = name
    end
end

function audio.stopMusic()
    if G.musicPlaying then
        love.audio.stop(AudioData[G.musicPlaying])
        G.musicPlaying = nil
    end
end

return audio
