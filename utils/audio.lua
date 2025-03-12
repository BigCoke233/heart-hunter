local audio = {}

local resources = {
    projectile = "sound/projectile.wav",
    intenseFight = "music/intenseFight.wav",
}

function audio.load()
    audioData = {}
    for name, path in pairs(resources) do
        audioData[name] = love.audio.newSource("resources/" .. path, "stream")
    end
end

function audio.play(name)
    if audioData[name] then
        love.audio.play(audioData[name])
    end
end

return audio
