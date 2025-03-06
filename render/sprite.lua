local heartTypes = require "data.heartTypes"
sprite = {}

-- sprite resource management

local sprites = {}
local quads = {}

local spriteTypes = heartTypes
local spriteSheets = {
    { name = "apple", w = 32, h = 32 },
    { name = "lancer", w = 32, h = 32 },
    { name = "spiger", w = 32, h = 32 },
    { name = "librarian", w = 32, h = 32 },
    { name = "citrus-litulon", w = 32, h = 32 },
}

function sprite.get(type)
    return sprites[type]
end

function sprite.getQuad(type, index)
    if index then
        return quads[type][index]
    else return quads[type]
    end
end

function sprite.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- load single-image sprite
    for _, sprite in ipairs(spriteTypes) do
        local filename = "resources/sprites/" .. sprite .. ".png"
        sprites[sprite] = love.graphics.newImage(filename)
    end

    -- load sprite sheets and create quads for each sprite in the sheet
    for _, sheet in ipairs(spriteSheets) do
        local filename = "resources/sheets/" .. sheet.name .. ".png"
        local image = love.graphics.newImage(filename)
        sprites[sheet.name] = love.graphics.newImage(filename)

        local sheetQuads = {}

        local rows = math.floor(image:getHeight() / sheet.h)
        local columns = math.floor(image:getWidth() / sheet.w)

        local index = 1
        for row = 0, rows - 1 do
            for col = 0, columns - 1 do
                sheetQuads[index] = love.graphics.newQuad(
                    col * sheet.w, row * sheet.h,
                    sheet.w, sheet.h,
                    image:getWidth(), image:getHeight()
                )
                index = index + 1
            end
        end
        quads[sheet.name] = sheetQuads
    end
end

-- sprite drawer

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

function sprite.drawQuad(sheet, index, x, y, w, h, angle)
    local quad = quads[sheet][index]  -- 根据精灵表名称和索引获取 Quad
    love.graphics.draw(sprites[sheet], quad, x, y, angle or 0, w, h)
end
