local audio = {}

local resources = {
    shootNormal = "sound/shoot_normal.wav",
    shootFlash = "sound/shoot_flash.wav",
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
