local Body = require "objects.Body"

local Loot = {}
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

function Loot:update(dt)
    local loots = G.currentRoom.loots
    if self.body:collide(G.player.body, self.x, self.y, G.player.x, G.player.y) then
        local pickedLoot = table.remove(loots, utils.indexof(loots, self))
        table.insert(G.player.hearts, pickedLoot.type)
    end
end

return Loot
