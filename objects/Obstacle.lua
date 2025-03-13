require "data.directions"
local physics = require "logic.physics"

local Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle:new(name, location, body)
    local obj = {
        name = name,
        presetLocation = (type(location) == "string" and location) or nil,
        x = (type(location) == "table" and location.x) or nil,
        y = (type(location) == "table" and location.y) or nil,
        w = 50,
        h = 50,
    }

    setmetatable(obj, Obstacle)

    return obj
end

function Obstacle:update(dt)
    -- nothing yet
end

return Obstacle
