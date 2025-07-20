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

function Body:isMet(body, selfX, selfY, currentX, currentY, dv, dir)
    -- x,y should be the predicted next location of this body
    -- dv = speed * dt * direction
    local x, y
    if dir == Direction.LEFT or dir == Direction.RIGHT then
        x = currentX + dv
        y = currentY
    elseif dir == Direction.UP or dir == Direction.DOWN then
        x = currentX
        y = currentY + dv
    end

    return self:collide(body, selfX, selfY, x, y)
end

function Body:draw(x, y)
    if self.shape == "circle" then
        love.graphics.circle("fill", x, y, self.r)
    elseif self.shape == "rectangle" then
        love.graphics.rectangle("fill", x, y, self.w, self.h)
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
