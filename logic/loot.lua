local Loot = require "objects.loot"

loot = {}

function loot.drop(x, y, name)
    table.insert(G.currentRoom.loots, Loot:new(name, x, y))
end
