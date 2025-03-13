local Body = {}
Body.__index = Body

function Body:new(shape, sizeA, sizeB, zoom)
    local obj = {
        shape = shape,
        r = (shape == "circle" and sizeA or nil),
        w = (shape == "rectangle" and sizeA or nil),
        h = (shape == "rectangle" and sizeB or nil),
        zoom = zoom or 1
    }

    setmetatable(obj, Body)

    return obj
end

function Body:draw(x, y)
    if self.shape == "circle" then
        love.graphics.circle("fill", x, y, self.r)
    elseif self.shape == "rectangle" then
        love.graphics.rectangle("fill", x - self.w / 2, y - self.h / 2, self.w, self.h)
    end
end

function Body:drawSprite(spriteName, x, y, angle)
    local sprite = sprite.get(spriteName)
    local w, h = (self.shape == "circle" and self.r or self.w), (self.shape == "circle" and self.r or self.h)

    love.graphics.draw(sprite, x, y, angle,
        w / sprite:getWidth(),
        h / sprite:getHeight()
    )
end

function Body:drawQuad(sheet, index, x, y, angle)
    if self.shape == "circle" then
        local r = self.r
        local graphicR = r * self.zoom
        sprite.drawQuad(sheet, index, x - r, y - r, graphicR, graphicR, angle or 0)
    else
        local w, h = self.w, self.h
        local graphicW, graphicH = w * self.zoom, h * self.zoom
        sprite.drawQuad(sheet, index, x - w/2, y - h/2, graphicW, graphicH, angle or 0)
    end
end

return Body
