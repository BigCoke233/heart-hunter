local sprite = {}

heartTypes = {
    "arrowheart",
    "bigheart",
    "blockheart",
    "blueheart",
    "brokenheart",
    "brownheart",
    "giftheart",
    "greenheart",
    "mendingheart",
    "purpleheart",
    "radiantheart",
    "redheart",
    "shinyheart",
    "twinheart",
    "whiteheart",
    "yellowheart"
}

spriteTypes = heartTypes

function sprite.load()
    sprites = {}

    for _, sprite in pairs(spriteTypes) do
        local filename = "resources/sprites/" .. sprite .. ".png"
        sprites[sprite] = love.graphics.newImage(filename)
    end
end

return sprite
