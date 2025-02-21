Obstacle = {}
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
