local audio = {}

local soundResources = {
    shootNormal = "shoot_normal.wav",
    shootFlash = "shoot_flash.wav",
    hit = "hit.wav",
    hitGlass = "hit_glass.wav",
    levelComplete = "level_complete.wav"
}

local musicResources = {
    briskFight = "brisk_fight.wav",
    intenseFight = "intense_fight.wav"
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

function audio.play(name)
    if AudioData[name] then
        love.audio.play(AudioData[name])
    end
end

function audio.music(name)
    if G.musicPlaying == name then
        return
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
