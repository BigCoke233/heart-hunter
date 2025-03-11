require "data.directions"

local Body = require "objects.Body"

local physics = require "logic.physics"

local Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle:new(name, location, body)
    local obj = {
        name = name,
        presetLocation = (type(location) == "string" and location) or nil,
        x = (type(location) == "table" and location.x) or nil,
        y = (type(location) == "table" and location.y) or nil,
        body = body or Body:new("rectangle", 50, 50)
    }

    setmetatable(obj, Obstacle)

    return obj
end

function Obstacle:getBorders()
    local left = self.x
    local right = self.x + self.body.w
    local top = self.y
    local bottom = self.y + self.body.h

    return { left, right, top, bottom }
end

function Obstacle:isMet(body, currentX, currentY, dv, dir)
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

    return self.body:collide(body, self.x, self.y, x, y)
end

function Obstacle:update(dt)
    -- nothing yet
end

return Obstacle
