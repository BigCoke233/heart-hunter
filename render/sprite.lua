sprite = {}

local spriteTypes = heartTypes
local spriteSheets = { "apple" }

function sprite.load()
    sprites = {}
    quads = {}

    love.graphics.setDefaultFilter("nearest", "nearest")

    -- 加载普通的单一图片精灵
    for _, sprite in ipairs(spriteTypes) do
        local filename = "resources/sprites/" .. sprite .. ".png"
        sprites[sprite] = love.graphics.newImage(filename)
    end

    -- 加载精灵表，并为每个精灵表中的每个精灵创建对应的 Quad
    for _, sheet in ipairs(spriteSheets) do
        local filename = "resources/sheets/" .. sheet .. ".png"
        local image = love.graphics.newImage(filename)
        sprites[sheet] = love.graphics.newImage(filename)

        local sheetQuads = {}
        local spriteWidth, spriteHeight = 32, 32

        local rows = math.floor(image:getHeight() / spriteHeight)
        local columns = math.floor(image:getWidth() / spriteWidth)

        for row = 0, rows - 1 do
            for col = 0, columns - 1 do
                local index = row * columns + col
                sheetQuads[index] = love.graphics.newQuad(col * spriteWidth, row * spriteHeight, spriteWidth, spriteHeight, image:getWidth(), image:getHeight())
            end
        end
        quads[sheet] = sheetQuads
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

function sprite.drawQuad(sheet, index, x, y, width, height, angle)
    local quad = quads[sheet][index]  -- 根据精灵表名称和索引获取 Quad
    love.graphics.draw(sprites[sheet], quad, x, y, angle or 0,
        width / quad:getWidth(),
        height / quad:getHeight()
    )
end
