local physics = require "logic.physics"

local Loot = {}
Loot.__index = Loot

function Loot:new(name, x, y)
    local obj = {
        x = x or nil,
        y = y or nil,
        type = name,
        r = config.lootSize
    }

    setmetatable(obj, Loot)
    G.BodyLifeCycleManager:create(obj, config.lootSize, "static", true)

    return obj
end

function Loot:onContact(other)
    local loots = G.currentRoom.objects.loots
    if other.objectType == "player" then
        local pickedLoot = table.remove(loots, utils.indexof(loots, self))
        table.insert(G.player.hearts, pickedLoot.type)
        G.BodyLifeCycleManager:destroy(self.physicsBody)
    end
end

function Loot:update(dt)
    -- nothing yet
end

return Loot
