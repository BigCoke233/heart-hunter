sprite = {}

local spriteTypes = heartTypes

function sprite.load()
    sprites = {}

    for _, sprite in ipairs(spriteTypes) do
        local filename = "resources/sprites/" .. sprite .. ".png"
        sprites[sprite] = love.graphics.newImage(filename)
    end
end

function sprite.draw(type, x, y, angle, width, height)
    local sprite = sprites[type]
    love.graphics.draw(sprite, x, y, angle,
        width / sprite:getWidth(),
        height / sprite:getHeight()
    )
end

function sprite.drawObject(type, position, angle, width, height)
   sprite.draw(type, position.x, position.y, angle, width, height)
end

function sprite.drawSquare(type, position, size)
    sprite.drawObject(type, position, 0, size, size)
end

function sprite.drawSquareWithAngle(type, position, angle, size)
    sprite.drawObject(type, position, angle, size, size)
end
