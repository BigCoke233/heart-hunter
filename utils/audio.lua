local audio = {}

local resources = {
    projectile = "sound/projectile.wav",
    hit = "sound/hit.wav",
}

function audio.load()
    audioData = {}
    for name, path in pairs(resources) do
        audioData[name] = love.audio.newSource("resources/" .. path, "static")
    end
end

function audio.play(name)
    if audioData[name] then
        love.audio.play(audioData[name])
    end
end

return audio
