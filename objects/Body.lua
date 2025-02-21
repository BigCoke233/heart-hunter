Body = {}
Body.__index = Body

function Body:new(shape, sizeA, sizeB, sizeC)
    local obj = {
        shape = shape,
        r = (shape == "circle" and sizeA or nil),
        w = (shape == "rectangle" and sizeA or nil),
        h = (shape == "rectangle" and sizeB or nil)
    }

    setmetatable(obj, Body)

    return obj
end

function Body:collide(other, x1, y1, x2, y2)
    if self.shape == "circle" and other.shape == "circle" then
        -- circle to circle
        local dx = x2 - x1
        local dy = y2 - y1
        local distance = math.sqrt(dx * dx + dy * dy)
        return distance < (self.r + other.r)
    elseif self.shape == "rectangle" and other.shape == "rectangle" then
        -- rect to rect
        return x1 < x2 + other.w and x1 + self.w > x2 and y1 < y2 + other.h and y1 + self.h > y2
    elseif self.shape == "circle" and other.shape == "rectangle" then
        -- circle to rect
        local closestX = math.max(x2, math.min(x1, x2 + other.w))
        local closestY = math.max(y2, math.min(y1, y2 + other.h))
        local dx = x1 - closestX
        local dy = y1 - closestY
        return (dx * dx + dy * dy) < (self.r * self.r)
    elseif self.shape == "rectangle" and other.shape == "circle" then
        return other:collide(self, x2, y2, x1, y1)
    end

    return false
end

function Body:draw(x, y, offsetFix)
    if self.shape == "circle" then
        local offset = offsetFix and - self.r / 2 or 0
        love.graphics.circle("fill", x + offset, y + offset, self.r)
    elseif self.shape == "rectangle" then
        local offsetX = offsetFix and - self.w / 2 or 0
        local offsetY = offsetFix and - self.h / 2 or 0
        love.graphics.rectangle("fill", x + offsetX, y + offsetY, self.w, self.h)
    end
end

function Body:drawSprite(spriteName, x, y, angle)
    local sprite = sprites[spriteName]
    local w, h = (self.shape == "circle" and self.r or self.w), (self.shape == "circle" and self.r or self.h)

    love.graphics.draw(sprite, x, y, angle,
        w / sprite:getWidth(),
        h / sprite:getHeight()
    )
end
