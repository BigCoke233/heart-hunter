Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle:new(name, location, body)
    local obj = {
        name = name,
        presetLocation = (type(location) == "string" and location) or nil,
        x = (type(location) == "table" and location.x) or nil,
        y = (type(location) == "table" and location.y) or nil,
        body = body or Body:new("rectangle", 10, 10)
    }

    setmetatable(obj, Obstacle)

    return obj
end
