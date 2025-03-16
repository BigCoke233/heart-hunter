local heartTypes = require "data.heartTypes"

local Loot = {}
Loot.__index = Loot

function Loot:new(name, x, y)
    local obj = {
        objectType = "loot",
        x = x or nil,
        y = y or nil,
        type = name,
        r = config.lootSize
    }

    setmetatable(obj, Loot)
    G.BodyLifeCycleManager:create(obj, config.lootSize, "static", true)

    return obj
end

function Loot:random(x, y)
    local type = utils.any(heartTypes)
    return Loot:new(type, x, y)
end

function Loot:onContact(other)
    local loots = G.currentRoom.objects.loots
    if other.objectType == "player" then
        local pickedLoot = table.remove(loots, utils.indexof(loots, self))
        G.player:gainHeart(pickedLoot.type)
        G.BodyLifeCycleManager:destroy(self.physicsBody)
    end
end

function Loot:placeInRoom()
    G.BodyLifeCycleManager:create(self, config.lootSize, "static", true)
end

function Loot:update(dt)
    -- nothing yet
end

return Loot
