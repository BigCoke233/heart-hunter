require "data.directions"
local physics = require "logic.physics"

local Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle:new(name, location, body)
    local obj = {
        objectType = "obstacle",
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

function Obstacle:placeInRoom(room)
    local offset = self.w + G.player.r*2 + config.summonMargin
    if not self.x or not self.y then
        self.x, self.y = room:getLocation(self.presetLocation or "random", offset)
    end
    G.BodyLifeCycleManager:create(self, { self.w, self.h }, "static")
end

function Obstacle:update(dt)
    -- nothing yet
end

return Obstacle
