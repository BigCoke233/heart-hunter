local Body = require "objects.Body"

Loot = {}
Loot.__index = Loot

function Loot:new(name, x, y)
    local obj = {
        x = x or nil,
        y = y or nil,
        type = name,
        body = Body:new("circle", config.lootSize)
    }

    setmetatable(obj, Loot)

    return obj
end
