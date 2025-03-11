local Loot = require "objects.loot"

loot = {}

function loot.drop(x, y, name)
    table.insert(G.currentRoom.objects.loots, Loot:new(name, x, y))
end
